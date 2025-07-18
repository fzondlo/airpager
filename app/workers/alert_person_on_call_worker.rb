class AlertPersonOnCallWorker
  include Sidekiq::Worker
  include SystemConfig

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

    alert = "Tienes un mensaje pendiente de AirBnB con Prioridad #{urgency_level} de #{message.sender_full_name}"
    Waapi.gateway.send_message(alert, STAFF_PHONE_NUMBERS[STAFF_ON_CALL])
    Waapi.gateway.send_message("#{alert} - sent to #{STAFF_ON_CALL}", LOGGING_WA_GROUP)
  end
end
