class HospitableWebhooksController
  class MessageCreatedHandler
    attr_reader :message

    def initialize(payload)
      @message = MessageCreated.new(payload)
    end

    def perform
      if message.from_guest?
        handle_guest_message
      elsif message.from_team?
        handle_team_message
      end
    end

    private

    def handle_guest_message
      return if pending_incident.present?

      # TODO: Generate prompt for ChatGPT with a class
      # TODO: Send prompt to ChatGPT to check if needs reply from team
      # TODO: If not, don't create incident

      Incident.create!(
        kind: 'pending_reply',
        source_details: {
          platform: message.platform,
          conversation_id: message.conversation_id
        }
      )

      # NotifyTeamOfIncidentWorker.perform_in(15.minutes, incident_id: incident.id)
    end

    def handle_team_message
      pending_incident&.resolve!(by: message.sender_full_name)
    end

    def pending_incident
      @pending_incident ||= Incident
        .pending
        .where(kind: "pending_reply")
        .where("source_details ->> 'conversation_id' = ?", message.conversation_id)
        .first
    end

    def conversation_messages
      @conversation_messages ||= begin
        # Hospitable does not let us retrieve messages per conversation_id,
        # only per reservation_id.
        response = Hospitable.gateway.find_reservation_messages(message.reservation_id)

        return [] unless response.success?

        response.select_conversation_messages(message.conversation_id)
      end
    end
  end
end
