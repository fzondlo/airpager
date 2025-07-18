class HospitableWebhooksController
  class MessageCreatedHandler
    attr_reader :message

    def initialize(payload)
      @message = MessageCreated.new(payload)
    end

    def perform
      store_message!

      if message.from_team?
        return resolve_pending_incident
      end

      if message.from_guest? && !pending_incident.present?
        incident = create_incident

        log_suggested_reply
        MessageEscalationPath.new(urgency_level, stored_message, incident).escalate
      end
    end

    private

    def store_message!
      @stored_message = Message.create!(
        conversation_id: message.conversation_id,
        reservation_id: message.reservation_id,
        sender_role: message.sender_role,
        sender_type: message.sender_type,
        sender_full_name: message.sender_full_name,
        content: message.body,
        posted_at: message.created_at
      )
    end

    def stored_message
      @stored_message
    end

    def urgency_level
      MessageUrgency.new(stored_message).urgency_level
    end

    def log_suggested_reply
      SuggestedReply.new(stored_message).log
    end

    def create_incident
      @create_incident ||= Incident.create!(
        kind: "pending_reply",
        source_details: {
          platform: message.platform,
          conversation_id: message.conversation_id,
          reservation_id: message.reservation_id,
          message_trigger_id: stored_message.id
        }
      )
    end

    def resolve_pending_incident
      pending_incident&.tap do |incident|
        incident.resolve!(by: message.sender_full_name)
        incident.update!(
          source_details: incident.source_details.merge(
            message_resolution_id: stored_message.id
          )
        )
      end
    end

    def pending_incident
      @pending_incident ||= begin
        scope = Incident
          .pending
          .where(kind: "pending_reply")
          .where("source_details ->> 'conversation_id' = ?", message.conversation_id)

        if message.reservation_id.present?
          scope = scope.where("source_details ->> 'reservation_id' = ?", message.reservation_id)
        else
          scope = scope.where("source_details ->> 'reservation_id' IS NULL")
        end

        scope.first
      end
    end
  end
end
