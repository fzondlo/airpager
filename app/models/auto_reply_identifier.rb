class AutoReplyIdentifier
  attr_reader :message, :property_id

  def initialize(message:, property_id:)
    @message = message
    @property_id = property_id
  end

  def resolve
    return if auto_replies.empty?

    response = OpenAi.gateway.find_auto_reply(prompt, message)

    if response.success? && response.auto_reply_id.present?
      AutoReply.find(response.auto_reply_id)
    end
  end

  private

  def auto_replies
    return ::AutoReply.none unless property_id.present?

    ::AutoReply.joins(:properties).where(properties: { id: property_id })
  end

  def prompt
    Prompt.find_auto_reply(auto_replies)
  end
end
