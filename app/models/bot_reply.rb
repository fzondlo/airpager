class BotReply
  include Task::Mapping # TODO: This is more a global config than a Task::Mapping

  FALLBACK_MESSAGE = "Sorry, I don't have an answer for that.".freeze

  attr_reader :message, :property_id

  def initialize(message:, property_id:)
    @message = message
    @property_id = property_id
  end

  def reply
    return FALLBACK_MESSAGE if auto_replies.empty?

    response = OpenAi.gateway.auto_reply(prompt, message)

    if response.success?
      response.answer
    else
      "Error: Unable to connect to OpenAI ..."
    end
  end

  def log_reply
    Waapi.gateway.send_message("[BotReply] [Message: #{@message.content}] [Reply: #{reply}]", LOGGING_WA_GROUP)
  end

  private

  def auto_replies
    return ::AutoReply.none unless property_id.present?

    ::AutoReply.joins(:properties).where(properties: { id: property_id })
  end

  def prompt
    Prompt.bot_reply(auto_replies, FALLBACK_MESSAGE)
  end
end
