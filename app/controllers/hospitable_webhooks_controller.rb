class HospitableWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    unless payload["action"] == "message.created"
      render json: { message: :success } and return
    end

    message_created = HospitalWebhookMessageCreated.new(payload)

    if message_created.from_guest?
      pending_incident = Incident
        .pending
        .where(kind: "pending_reply")
        .where("source_details ->> 'conversation_id' = ?", message_created.conversation_id)
        .first

      unless pending_incident.present?
        incident = Incident.create(
          kind: 'pending_reply',
          source_details: {
            platform: message_created.platform,
            conversation_id: message_created.conversation_id
          }
        )

        NotifyTeamOfIncidentWorker.perform_in(15.minutes, incident_id: incident.id)
      end

      render json: { message: :success } and return
    end

    if message_created.from_team?
      pending_incident = Incident
        .pending
        .where(kind: "pending_reply")
        .where("source_details ->> 'conversation_id' = ?", message_created.conversation_id)
        .first

      if pending_incident.present?
        pending_incident.resolve!
      end
    end

    render json: { message: :success }
  end

  private

  def payload
    payload = {
      "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
      "data": {
        "platform": "airbnb",
        "platform_id": 0,
        "conversation_id": "becd1474-ccd1-40bf-9ce8-04456bfa338d",
        "reservation_id": "becd1474-ccd1-40bf-9ce8-04456bfa338d",
        "content_type": "text/plain",
        "body": "Hello, there.",
        "attachments": [
          {
            "type": "image",
            "url": "The image location URL"
          }
        ],
        "sender_type": "host",
        "sender_role": "host|co-host|teammate|null",
        "sender": {
          "first_name": "Jane",
          "full_name": "Jane Doe",
          "locale": "en",
          "picture_url": "https://a0.muscache.com/im/pictures/user/f391da23-c76e-4728-a9f2-25cc139a13cc.jpg?aki_policy=profile_x_medium",
          "thumbnail_url": "https://a0.muscache.com/im/pictures/user/f391da23-c76e-4728-a9f2-25cc139a13cc.jpg?aki_policy=profile_x_medium",
          "location": null
        },
        "user": {
          "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
          "email": "user@example.com",
          "name": "string"
        },
        "created_at": "2019-07-29T19:01:14Z"
      },
      "action": "message.created",
      "created": "2024-10-08T07:03:34Z",
      "version": "v2"
    }
  end
end
