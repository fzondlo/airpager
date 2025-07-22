class AutoReplyUsageViewModel < ApplicationViewModel
  def message_trigger_content
    return unless model.message_trigger_id.present?

    @message_trigger_content ||= Message.find(model.message_trigger_id)&.content
  end
end
