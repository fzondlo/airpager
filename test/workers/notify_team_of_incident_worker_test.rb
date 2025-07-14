require "test_helper"
require "minitest/mock"

class NotifyTeamOfIncidentWorkerTest < ActiveSupport::TestCase
  def setup
    @incident = create_incident
    @worker = NotifyTeamOfIncidentWorker.new
    @mock = Minitest::Mock.new
  end

  def test_skips_if_incident_not_found
    assert_equal "created", @incident.status

    Allquiet::BogusGateway.any_instance.expects(:create_incident).never

    @worker.perform(-1) # Non-existent ID

    assert_equal "created", @incident.reload.status
  end

  def test_skips_if_incident_is_resolved
    assert_equal "created", @incident.status

    @incident.resolve!(by: "console")
    assert_equal "resolved", @incident.status

    Allquiet::BogusGateway.any_instance.expects(:create_incident).never

    @worker.perform(@incident.id)
    assert_equal "resolved", @incident.reload.status
  end

  def test_creates_incident_and_alerts_when_valid
    assert_equal "created", @incident.status

    Allquiet::BogusGateway.any_instance.expects(:create_incident).once

    @worker.perform(@incident.id)
    assert_equal "alerted", @incident.reload.status
  end
end
