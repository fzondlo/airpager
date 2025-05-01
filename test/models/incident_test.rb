require "test_helper"

class IncidentTest < ActiveSupport::TestCase
  test "resolved?'" do
    incident = create_incident(status: "created")
    assert_not incident.resolved?

    incident = create_incident(status: "alerted")
    assert_not incident.resolved?

    incident = create_incident(status: "resolved")
    assert incident.resolved?
  end

  test "resolve! updates status and resolved fields" do
    incident = create_incident
    incident.resolve!(by: "console")

    assert_equal "resolved", incident.status
    assert_equal "console", incident.resolved_by
    assert_not_nil incident.resolved_at
    assert incident.resolved?
  end
end
