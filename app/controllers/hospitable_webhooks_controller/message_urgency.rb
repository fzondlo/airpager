class HospitableWebhooksController
  class MessageUrgency
    attr_reader :message

    URGENCY = {
      NO_RESPONSE_REQUIRED: :P0,
      P1: :P1,
      P2: :P2,
      P3: :P3,
      NO_RESERVATION: :P3
    }.freeze

    def initialize(message)
      @message = message
    end

    def urgency
      return URGENCY[:NO_RESPONSE_REQUIRED] if is_lead? || likely_image?
      urgency_from_chatgpt
    end

    private

    def is_lead?
      message.reservation_id.nil?
    end

    def likely_image?
      message.content.nil?
    end

    def conversation_messages
      @conversation_messages ||= Message.where(conversation_id: message.conversation_id, reservation_id: message.reservation_id).order(posted_at: :desc).limit(5).all.reverse
    end

    def urgency_from_chatgpt
      response = ::OpenAi.gateway.chat(prompt)

      unless response.success?
        return URGENCY[:P1]
      end

      OpenAiRequest.create(
        prompt: prompt,
        answer: response.answer,
        response_payload: response.body
      )

      chatgpt_urgency_level = JSON.parse(response.answer).dig("urgency")

      unless chatgpt_urgency_level.to_sym.in?(URGENCY.keys)
        Rails.logger.warn "ChatGPT returned an unknown urgency: #{response.answer}"
        return URGENCY[:P1]
      end

      URGENCY[chatgpt_urgency_level.to_sym]
    end

    def prompt
      @prompt ||= Prompt.ensure_conversation_needs_reply_from_team(conversation_messages)
    end
  end
end
