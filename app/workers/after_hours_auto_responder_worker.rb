class AfterHoursAutoResponderWorker
  include Sidekiq::Worker

  AUTO_RESPOND_TEXT = <<~TEXT
    You’ve caught us outside of our usual hours, but no worries — someone from our team will get back to you first thing in the morning.
    We appreciate your patience and look forward to helping you soon.
  TEXT

  def perform(incident_id)
    incident = IncidentViewModel.wrap(Incident.find_by(id: incident_id))

    unless incident.present?
      Sidekiq.logger.warn "Incident #{incident_id} not found. Skipping."
      return
    end

    conversation_id = incident.source_details&.conversation_id
    reservation_id = incident.source_details&.reservation_id

    unless conversation_id.present?
      Sidekiq.logger.warn "Conversation ID for Incident #{incident_id} not found. Skipping."
      return
    end

    most_recent_message = MessageViewModel.wrap(
      Message.where(conversation_id: conversation_id, reservation_id: reservation_id).order(posted_at: :desc).first
    )

    unless most_recent_message.present?
      Sidekiq.logger.warn "Most recent message for Incident #{incident_id} not found. Skipping."
      return
    end

    unless most_recent_message.from_guest?
      Sidekiq.logger.warn "Most recent message for Incident #{incident_id} is not from guest. Skipping."
      return
    end

    if reservation_id.present?
      puts "Reservation auto respond: #{AUTO_RESPOND_TEXT}"
      # Hospitable.gateway.send_message_for_reservation(reservation_id, AUTO_RESPOND_TEXT)
      return
    end

    puts "Inquiry auto respond: #{AUTO_RESPOND_TEXT}"
    # Hospitable.gateway.send_message_for_inquiry(reservation_id, AUTO_RESPOND_TEXT)
  end
end

