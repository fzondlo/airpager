class HospitableWebhooksController
  class MessageCreatedHandler
    attr_reader :message

    def initialize(payload)
      @message = HospitableWebhookMessageCreated.new(payload)
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

      # messages = Hospitable.gateway.messages_for_reservation(@message.reservation_id)
      # return unless ChatGPT.gateway.message_needs_reply?(messages)

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
  end
end
