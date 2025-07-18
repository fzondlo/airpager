class IncidentEscalationsController < ApplicationController
  include SystemConfig

  def show
    @show_header = false

    escalation = IncidentEscalation.find_by!(token: params[:token])

    if escalation.expired?
      @status = :expired
    elsif escalation.triggered?
      @status = :already_triggered
    else
      notify_team("Guest clicked link to escalate incident ##{escalation.incident_id}")
      escalation.triggered!
      @status = :triggered_now
    end

    render :show
  end

  private

  def notify_team(message)
    Waapi.gateway.send_message(message, LOGGING_WA_GROUP)
  end
end
