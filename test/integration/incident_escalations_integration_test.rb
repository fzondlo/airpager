require "test_helper"

class IncidentEscalationsIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @incident = create_incident
  end

  def test_active_escalation
    escalation = IncidentEscalation.create!(incident: @incident)

    # Allow any other send_message calls to go through without raising errors
    Waapi::BogusGateway.any_instance.stubs(:send_message)

    # Assert that the escalation message is sent exactly once
    Waapi::BogusGateway.any_instance.expects(:send_message).with do |message|
      message.include?("Escalation triggered for incident")
    end.once

    get incident_escalation_path(token: escalation.token)

    assert_response :success
    assert_match "Our team has been notified. We will respond shortly.", response.body

    escalation.reload
    assert escalation.triggered?
  end

  def test_expired_escalation
    escalation = IncidentEscalation.create!(
      incident: @incident,
      expires_at: 1.hour.ago
    )

    Waapi::BogusGateway.any_instance.stubs(:send_message)
    Waapi::BogusGateway.any_instance.expects(:send_message).with do |message|
      message.include?("Escalation triggered for incident")
    end.never

    get incident_escalation_path(token: escalation.token)

    assert_response :success
    assert_match "This escalation link is no longer valid.", response.body

    escalation.reload
    assert escalation.expired?
    refute escalation.triggered?
  end

  def test_triggered_escalation
    escalation = IncidentEscalation.create!(
      incident: @incident,
      triggered_at: Time.current
    )

    Waapi::BogusGateway.any_instance.stubs(:send_message)
    Waapi::BogusGateway.any_instance.expects(:send_message).with do |message|
      message.include?("Escalation triggered for incident")
    end.never

    get incident_escalation_path(token: escalation.token)

    assert_response :success
    assert_match "This escalation link has already been escalated. Our team will respond shortly.", response.body
  end
end
