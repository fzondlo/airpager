require 'test_helper'

class HospitableWebhooksIntegrationTest < ActionDispatch::IntegrationTest
  def test_creates_incident_when_message_from_guest
    assert_difference -> { Incident.count }, 1 do
      post_hospitable_message_webhook(conversation_id: "test-convo-123", reservation_id: "test-reservation-123", sender_role: "", sender_type: "guest")
    end

    incident = Incident.first
    assert_equal "pending_reply", incident.kind
    assert_equal "test-convo-123", incident.source_details["conversation_id"]
    assert_equal "test-reservation-123", incident.source_details["reservation_id"]
  end

  def test_messages_received_are_stored
    assert_difference -> { Message.count }, 2 do
      2.times { post_hospitable_message_webhook }
    end
  end

  def test_does_not_create_duplicate_incident
    Incident.create!(
      kind: "pending_reply",
      source_details: {
        platform: "airbnb",
        conversation_id: "test-convo-456"
      }
    )

    assert_no_difference -> { Incident.count } do
      post_hospitable_message_webhook(conversation_id: "test-convo-456", sender_role: "", sender_type: "guest")
    end
  end

  def test_resolves_incident_when_message_from_team
    incident = Incident.create!(
      kind: "pending_reply",
      source_details: {
        platform: "airbnb",
        conversation_id: "test-convo-789"
      },
      resolved_at: nil
    )

    post_hospitable_message_webhook(conversation_id: "test-convo-789", sender_role: "co-host", sender_type: "host")

    incident.reload

    assert incident.resolved_at.present?
    assert incident.resolved_by.present?
  end

  private

  def post_hospitable_message_webhook(conversation_id: "becd1474-ccd1-40bf-9ce8-04456bfa338d", reservation_id: "becd1474-ccd1-40bf-9ce8-04456bfa338d", sender_role: nil, sender_type: "guest")
    post "/hospitable_webhooks", params: {
      id: "497f6eca-6276-4993-bfeb-53cbbbba6f08",
      data: {
        platform: "airbnb",
        platform_id: 0,
        conversation_id: conversation_id,
        reservation_id: reservation_id,
        content_type: "text/plain",
        body: "Hello, there.",
        sender_type: "host",
        sender_role: sender_role,
        sender: {
          first_name: "Jane",
          full_name: "Jane Doe",
          locale: "en",
          picture_url: "https://a0.muscache.com/im/pictures/user/f391da23.jpg",
          thumbnail_url: "https://a0.muscache.com/im/pictures/user/f391da23.jpg",
          location: "null"
        },
        user: {
          id: "497f6eca-6276-4993-bfeb-53cbbbba6f08",
          email: "user@example.com",
          name: "string"
        },
        created_at: "2019-07-29T19:01:14Z"
      },
      action: "message.created",
      created: "2024-10-08T07:03:34Z",
      version: "v2"
    }.to_json, headers: { "Content-Type" => "application/json" }
  end
end
