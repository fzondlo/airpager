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

        if needs_reply_from_team?
          incident = create_incident

          NotifyTeamOfIncidentWorker.perform_in(15.minutes, incident.id)

          if after_hours? && message.reservation_id.present?
            AfterHoursAutoResponderWorker.perform_in(2.minutes, message.reservation_id)
          end
        end
      end
    end

    private

    def store_message
      Message.create!(
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
      Incident.create!(
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

    def needs_reply_from_team?
      prompt = Prompt.ensure_conversation_needs_reply_from_team(conversation_messages)

      response = ::OpenAi.gateway.chat(prompt)

      unless response.success?
        return true
      end

      OpenAiRequest.create(
        prompt: prompt,
        answer: response.answer,
        response_payload: response.body
      )

      unless response.answer.in?([ "TRUE", "FALSE" ])
        return true
      end

      ActiveModel::Type::Boolean.new.cast(response.answer)
    end

    def pending_incident
      @pending_incident ||= Incident
        .pending
        .where(kind: "pending_reply")
        .where("source_details ->> 'conversation_id' = ?", message.conversation_id)
        .where("source_details ->> 'reservation_id' = ?", message.reservation_id)
        .first
    end

    def conversation_messages
      @conversation_messages ||= Message.where(conversation_id: message.conversation_id, reservation_id: message.reservation_id).order(posted_at: :desc).limit(5).all.reverse
    end

    def after_hours?
      current_hour = Time.zone.now.hour

      !current_hour.between?(8, 21)
    end
  end
end
