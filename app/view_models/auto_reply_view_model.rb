class AutoReplyViewModel < ApplicationViewModel
  def property_names_display
    if model.properties.any?
      model.properties.map(&:name).sort.join(", ")
    else
      "No properties selected"
    end
  end

  def sandbox_usages
    @sandbox_usages ||= AutoReplyUsageViewModel.wrap(
      AutoReplyUsage.where(auto_reply_id: model.id, usage_type: "sandbox").order(created_at: :desc)
    )
  end

  def live_usages
    @live_usages ||= AutoReplyUsageViewModel.wrap(
      AutoReplyUsage.where(auto_reply_id: model.id, usage_type: "live").order(created_at: :desc)
    )
  end

  def trigger_context_display
    return model.trigger_context.capitalize unless model.trigger_context == 'both'

    'Inquiry and Reservation'
  end
end
