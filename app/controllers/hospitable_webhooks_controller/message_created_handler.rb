class HospitableWebhooksController
  class MessageCreatedHandler
    attr_reader :message

    def initialize(payload)
      @message = MessageCreated.new(payload)
    end

    def perform
      store_message

      if message.from_team?
        return resolve_pending_incident
      end

      if message.from_guest? && !pending_incident.present?
        return create_incident

        # NotifyTeamOfIncidentWorker.perform_in(15.minutes, incident_id: incident.id)
      end
    end

    private

    def store_message
      Message.create!(
        conversation_id: message.conversation_id,
        reservation_id: message.reservation_id,
        sender_role: message.sender_role,
        sender_full_name: message.sender_full_name,
        content: message.body,
        posted_at: message.created_at
      )
    end

    def create_incident
      Incident.create!(
        kind: 'pending_reply',
        source_details: {
          platform: message.platform,
          conversation_id: message.conversation_id,
          reservation_id: message.reservation_id
        }
      )
    end

    def resolve_pending_incident
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
