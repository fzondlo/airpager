class HospitableWebhooksController
  class MessageCreatedHandler
    attr_reader :message

    def initialize(payload)
      @message = MessageCreated.new(payload)
    end

    def perform
      stored_message # to store every message

      if message.from_team?
        return resolve_pending_incident
      end

      if message.from_guest? && !pending_incident.present?
        # TODO
        #
        # Connect the dots: resolve property and then use bot reply
        #
        # PropertyIdentifier.new(stored_message).resolve
        # BotReply.new(message: "", property_id: "").log_reply

        MessageEscalationPath.new(urgency, stored_message, create_incident).escalate
      end
    end

    private

    def urgency
      MessageUrgency.new(stored_message).urgency
    end

    def stored_message
      @stored_message ||= Message.create!(
        conversation_id: message.conversation_id,
        reservation_id: message.reservation_id,
        sender_role: message.sender_role,
        sender_type: message.sender_type,
        sender_full_name: message.sender_full_name,
        content: message.body,
        posted_at: message.created_at
      )
    end

    def create_incident
      @create_incident ||= Incident.create!(
        kind: "pending_reply",
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
