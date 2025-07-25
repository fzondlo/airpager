require "test_helper"

class HospitableWebhooksIntegrationTest < ActionDispatch::IntegrationTest
  def test_creates_incident_when_message_from_guest
    assert_difference -> { Incident.count }, 1 do
      post_hospitable_message_webhook(conversation_id: "test-convo-123", reservation_id: "test-reservation-123", sender_role: "", sender_type: "guest")
    end

    incident = Incident.first
    assert_equal "pending_reply", incident.kind
    assert_equal "test-convo-123", incident.source_details["conversation_id"]
    assert_equal "test-reservation-123", incident.source_details["reservation_id"]
    assert_equal Message.first.id, incident.source_details["message_trigger_id"]
    assert incident.urgency_level.present?

    # Test when no reservation_id
    assert_difference -> { Incident.count }, 1 do
      post_hospitable_message_webhook(conversation_id: "test-convo-124", reservation_id: "", sender_role: "", sender_type: "guest")
    end

    incident = Incident.last
    assert_equal "pending_reply", incident.kind
    assert_equal "test-convo-124", incident.source_details["conversation_id"]
    assert_equal "", incident.source_details["reservation_id"]
    assert_equal Message.last.id, incident.source_details["message_trigger_id"]
    assert incident.urgency_level.present?
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
        conversation_id: "test-convo-456",
        reservation_id: "test-resa-456"
      }
    )

    assert_no_difference -> { Incident.count } do
      post_hospitable_message_webhook(conversation_id: "test-convo-456", reservation_id: "test-resa-456", sender_role: "", sender_type: "guest")
    end

    # Test when no reservation_id
    Incident.create!(
      kind: "pending_reply",
      source_details: {
        platform: "airbnb",
        conversation_id: "test-convo-457"
      }
    )

    assert_no_difference -> { Incident.count } do
      post_hospitable_message_webhook(conversation_id: "test-convo-457", reservation_id: "", sender_role: "", sender_type: "guest")
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

    post_hospitable_message_webhook(conversation_id: "test-convo-789", reservation_id: "", sender_role: "co-host", sender_type: "host")

    incident.reload

    assert incident.resolved_at.present?
    assert incident.resolved_by.present?
    assert_equal Message.first.id, incident.source_details["message_resolution_id"]
  end

  def test_notify_team_of_incident_worker_is_enqueued_when_message_from_guest
    assert_difference -> { NotifyTeamOfIncidentWorker.jobs.size }, 1 do
      post_hospitable_message_webhook(sender_role: "", sender_type: "guest")
    end
  end

  def test_alert_person_on_call_for_p1
    fake_response = stub(success?: true, answer: "{\n  \"urgency\": \"P1\"\n}", body: {})
    ::OpenAi.stubs(:gateway).returns(stub(chat: fake_response))

    # Allow any other send_message calls to go through without raising errors
    Waapi::BogusGateway.any_instance.stubs(:send_message)

    Waapi::BogusGateway.any_instance.expects(:send_message).with do |message|
      message.include?("Tienes un mensaje pendiente de AirBnB con Prioridad P1")
    end.once

    TwilioApi::BogusGateway.any_instance.expects(:create_call).once

    post_hospitable_message_webhook
  end

  def test_alert_person_on_call_for_p2
    fake_response = stub(success?: true, answer: "{\n  \"urgency\": \"P2\"\n}", body: {})
    ::OpenAi.stubs(:gateway).returns(stub(chat: fake_response))

    # Allow any other send_message calls to go through without raising errors
    Waapi::BogusGateway.any_instance.stubs(:send_message)

    Waapi::BogusGateway.any_instance.expects(:send_message).with do |message|
      message.include?("Tienes un mensaje pendiente de AirBnB con Prioridad P2")
    end.once

    TwilioApi::BogusGateway.any_instance.expects(:create_call).once

    post_hospitable_message_webhook
  end

  def test_sends_escalation_message_for_p3_after_hours
    travel_to Time.zone.parse("22:00:00") do
      fake_response = stub(success?: true, answer: "{\n  \"urgency\": \"P3\"\n}", body: {})
      ::OpenAi.stubs(:gateway).returns(stub(chat: fake_response))

      # Allow any other send_message calls to go through without raising errors
      Waapi::BogusGateway.any_instance.stubs(:send_message)

      # Assert that the escalation message is sent exactly once
      Waapi::BogusGateway.any_instance.expects(:send_message).with do |message|
        message.include?("If this is an urgent request click this link")
      end.once

      post_hospitable_message_webhook
    end
  end

  def test_does_not_send_escalation_message_during_business_hours
    travel_to Time.zone.parse("13:00:00") do
      fake_response = stub(success?: true, answer: "{\n  \"urgency\": \"P3\"\n}", body: {})
      ::OpenAi.stubs(:gateway).returns(stub(chat: fake_response))

      # Allow any other send_message calls to go through without raising errors
      Waapi::BogusGateway.any_instance.stubs(:send_message)

      # Assert that the escalation message is never sent
      Waapi::BogusGateway.any_instance.expects(:send_message).with do |message|
        message.include?("If this is an urgent request click this link")
      end.never

      post_hospitable_message_webhook
    end
  end

  def test_does_not_send_escalation_message_for_non_p3
    travel_to Time.zone.parse("22:00:00") do
      fake_response = stub(success?: true, answer: "{\n  \"urgency\": \"P1\"\n}", body: {})
      ::OpenAi.stubs(:gateway).returns(stub(chat: fake_response))

      # Allow any other send_message calls to go through without raising errors
      Waapi::BogusGateway.any_instance.stubs(:send_message)

      # Assert that the escalation message is never sent
      Waapi::BogusGateway.any_instance.expects(:send_message).with do |message|
        message.include?("If this is an urgent request click this link")
      end.never

      post_hospitable_message_webhook
    end
  end


  # TODO: Re-implement this test when we start to respond again
  # def test_auto_responder_worker_is_enqueued_after_hours
  #   travel_to Time.zone.parse("22:00:00") do
  #     assert_difference -> { AfterHoursAutoResponderWorker.jobs.size }, 1 do
  #       post_hospitable_message_webhook(sender_role: "", sender_type: "guest", reservation_id: "becd1474")
  #     end

  #     job = AfterHoursAutoResponderWorker.jobs.last
  #     assert_equal ["becd1474"], job["args"]
  #   end
  # end

  # TODO: Re-implement this test when we start to respond again
  # def test_auto_responder_worker_is_not_enqueued_after_hours_without_reservation_id
  #   travel_to Time.zone.parse("22:00:00") do
  #     assert_no_difference -> { AfterHoursAutoResponderWorker.jobs.size } do
  #       post_hospitable_message_webhook(sender_role: "", sender_type: "guest", reservation_id: nil)
  #     end
  #   end
  # end

  def test_auto_responder_worker_is_not_enqueued_during_normal_hours
    travel_to Time.zone.parse("14:00:00") do
      assert_no_difference -> { AfterHoursAutoResponderWorker.jobs.size } do
        post_hospitable_message_webhook(sender_role: "", sender_type: "guest", reservation_id: "becd1474")
      end
    end
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
