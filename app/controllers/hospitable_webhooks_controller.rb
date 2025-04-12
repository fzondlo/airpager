class HospitableWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    unless payload["action"] == "message.created"
      render json: { message: :success } and return
    end

    message_created = HospitableWebhookMessageCreated.new(payload)

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

        # NotifyTeamOfIncidentWorker.perform_in(15.minutes, incident_id: incident.id)
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
        pending_incident.resolve!(by: message_created.sender_full_name)
      end
    end

    render json: { message: :success }
  end

  private

  def payload
    JSON.parse(request.body.read)
  end
end
