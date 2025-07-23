class AutoReplyIdentifier
  attr_reader :message, :property

  def initialize(message:, property:)
    @message = message
    @property = property
  end

  def resolve
    return if auto_replies.empty?

    response = OpenAi.gateway.find_auto_reply(prompt, message.content, metadata: {
      message_id: message.id,
      reservation_id: message.reservation_id,
      conversation_id: message.conversation_id,
      property_id: property.id,
      hospitable_thread_url: "https://my.hospitable.com/inbox/thread/#{message.conversation_id}"
    })

    if response.success? && response.auto_reply_id.present?
      auto_replies.find_by(id: response.auto_reply_id)
    end
  end

  private

  def auto_replies
    return ::AutoReply.none unless property&.id.present?

    ::AutoReply.joins(:properties).where(properties: { id: property.id })
  end

  def prompt
    Prompt.find_auto_reply(auto_replies)
  end
end
