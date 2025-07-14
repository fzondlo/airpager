require "test_helper"

class IncidentEscalationTest < ActiveSupport::TestCase
  def setup
    @incident = create_incident
    @escalation = IncidentEscalation.create!(incident: @incident)
  end

  def test_token_is_generated_on_create
    assert @escalation.token.present?
  end

  def test_token_uniqueness
    copy = IncidentEscalation.new(incident: @incident, token: @escalation.token)

    refute copy.valid?
    assert_includes copy.errors[:token], "has already been taken"
  end

  def test_triggered
    refute @escalation.triggered?

    @escalation.triggered!

    assert @escalation.triggered?
  end

  def test_expired_when_triggered
    refute @escalation.expired?

    @escalation.triggered!

    assert @escalation.expired?
  end

  def test_expired_when_expires_at_in_past
    refute @escalation.expired?

    @escalation.update!(expires_at: 1.hour.ago)

    assert @escalation.expired?
  end

  def test_not_expired_when_expires_at_in_future
    refute @escalation.expired?

    @escalation.update!(expires_at: 1.hour.from_now)

    refute @escalation.expired?
  end

  def test_active_scope_includes_valid_escalations
    active_escalations = [
      @escalation,
      IncidentEscalation.create!(incident: @incident),
      IncidentEscalation.create!(incident: @incident, expires_at: 30.minutes.from_now),
      IncidentEscalation.create!(incident: @incident, expires_at: 1.hour.from_now),
      IncidentEscalation.create!(incident: @incident, expires_at: nil, triggered_at: nil),
    ]

    inactive_escalations = [
      IncidentEscalation.create!(incident: @incident, expires_at: 1.hour.ago),
      IncidentEscalation.create!(incident: @incident, expires_at: 2.hours.ago),
      IncidentEscalation.create!(incident: @incident, expires_at: nil, triggered_at: 1.hour.ago),
      IncidentEscalation.create!(incident: @incident, expires_at: 1.hour.from_now, triggered_at: 1.hour.ago),
    ]

    active_ids = IncidentEscalation.active.pluck(:id)

    assert_equal active_escalations.pluck(:id).sort, active_ids.sort
  end

  def test_expired_scope_includes_only_expired_escalations
    expired_escalations = [
      IncidentEscalation.create!(incident: @incident, expires_at: 1.hour.ago),
      IncidentEscalation.create!(incident: @incident, expires_at: 2.hours.ago),
    ]

    not_expired_escalations = [
      @escalation,
      IncidentEscalation.create!(incident: @incident, expires_at: 1.hour.from_now),
      IncidentEscalation.create!(incident: @incident, expires_at: nil),
    ]

    expired_ids = IncidentEscalation.expired.pluck(:id)

    assert_equal expired_escalations.pluck(:id).sort, expired_ids.sort
  end

  def test_triggered_scope_includes_only_triggered_escalations
    triggered_escalations = [
      IncidentEscalation.create!(incident: @incident, triggered_at: 1.hour.ago),
      IncidentEscalation.create!(incident: @incident, triggered_at: Time.current),
    ]

    not_triggered_escalations = [
      @escalation,
      IncidentEscalation.create!(incident: @incident, triggered_at: nil),
      IncidentEscalation.create!(incident: @incident),
    ]

    triggered_ids = IncidentEscalation.triggered.pluck(:id)

    assert_equal triggered_escalations.pluck(:id).sort, triggered_ids.sort
  end
end
