class AlertTeamWorker
  include Sidekiq::Worker
  include Task::Mapping

  def perform(incident_id, message_id, urgency_level)
    incident = Incident.find_by(id: incident_id)
    message = Message.find_by(id: message_id)

    unless incident.present?
      Sidekiq.logger.warn "Incident #{incident_id} not found. Skipping."
      return
    end

    if incident.resolved?
      Sidekiq.logger.warn "Incident #{incident_id} is resolved. Don't need to notify team. Skipping."
      return
    end

    alert = "Hay un mensaje pendiente de AirBnB con Prioridad #{urgency_level} de #{message.sender_full_name}"
    Waapi.gateway.send_message(alert, ALERT_INCIDENT_GROUP)
  end
end
