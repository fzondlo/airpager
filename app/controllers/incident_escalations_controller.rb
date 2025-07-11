class IncidentEscalationsController < ApplicationController
  include Task::Mapping # TODO: Need to improve naming / refactor

  def show
    escalation = IncidentEscalation.find_by!(token: params[:token])

    if escalation.expired?
      render plain: "This escalation link has expired.", status: :gone
      return
    end

    notify_team("Escalation triggered for incident ##{escalation.incident_id}")
    escalation.triggered!

    render plain: "Our team has been notified!"
  end

  private

  def notify_team(message)
    # Waapi.gateway.send_message(message, LOGGING_WA_GROUP)
  end
end
