require "test_helper"
require "minitest/mock"

class NotifyTeamOfIncidentWorkerTest < ActiveSupport::TestCase
  def setup
    @incident = create_incident
    @worker = NotifyTeamOfIncidentWorker.new
    @mock = Minitest::Mock.new
  end

  def test_skips_if_incident_not_found
    Allquiet.stub(:gateway, @mock) do
      @worker.perform(999)
      @mock.verify # No expectations; ensure no method calls are made
      assert_equal "created", @incident.status
    end
  end

  def test_skips_if_incident_is_resolved
    @incident.resolve!(by: "console")
    assert_equal "resolved", @incident.status

    Allquiet.stub(:gateway, @mock) do
      @worker.perform(@incident.id)
      @mock.verify # No expectations; ensure no method calls are made
      assert_equal "resolved", @incident.status
    end
  end

  def test_creates_incident_and_alerts_when_valid
    Allquiet.stub(:gateway, @mock) do
      @mock.expect(:create_incident, true)

      assert_equal "created", @incident.status
      @worker.perform(@incident.id)
      assert_equal "alerted", @incident.reload.status

      @mock.verify # Ensures that create_incident was called correctly
      assert_equal "alerted", @incident.status
    end
  end
end
