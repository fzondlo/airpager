class SuggestedReply
  include Task::Mapping

  attr_reader :message

  def initialize(message)
    @message = message
  end

  def log
    body =
      <<~TEXT
        New Message from #{message.sender_full_name}:
        #{message.content}

        -----

        Suggested Reply:
        #{auto_reply&.reply || "Sorry, I don't have an answer for that."}
      TEXT

    Waapi.gateway.send_message(body, LOGGING_WA_GROUP)

    # TODO: Track usage locally in a database table (conversation_id / auto_reply_id)
  end

  private

  def property_id
    @property_id ||= PropertyIdentifier.new(message).resolve
  end

  def auto_reply
    return unless property_id.present?

    @auto_reply ||= AutoReplyIdentifier.new(
      message: message.content,
      property_id: property_id
    ).resolve
  end
end
