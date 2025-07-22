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
end
