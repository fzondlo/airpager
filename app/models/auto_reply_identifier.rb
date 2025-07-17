class AutoReplyIdentifier
  attr_reader :message, :property_id, :live_mode

  def initialize(message:, property_id:, live_mode: false)
    @message = message
    @property_id = property_id
    @live_mode = live_mode
  end

  def resolve
    return if auto_replies.empty?

    response = OpenAi.gateway.find_auto_reply(prompt, message)

    if response.success? && response.auto_reply_id.present?
      auto_replies.find_by(id: response.auto_reply_id)
    end
  end

  private

  def auto_replies
    return ::AutoReply.none unless property_id.present?

    scope = ::AutoReply.joins(:properties).where(properties: { id: property_id })
    scope = scope.live_enabled if live_mode?
    scope
  end

  def live_mode?
    !!@live_mode
  end

  def prompt
    Prompt.find_auto_reply(auto_replies)
  end
end
