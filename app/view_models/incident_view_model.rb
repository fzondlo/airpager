class IncidentViewModel < ApplicationViewModel
  def status_background_class
    return 'bg-gray-500' if model.status == 'created'
    return 'bg-yellow-500' if model.status == 'alerted'
    return 'bg-green-500' if model.status == 'resolved'
  end

  def description
    return '💬 Pending team reply' if model.kind == 'pending_reply'
  end

  def created_at_display_time
    model.created_at.in_time_zone("America/Bogota").strftime("%B %-d, %Y – %H:%M")
  end

  def alerted_at_display_time
    return unless model.alerted_at.present?

    model.alerted_at.in_time_zone("America/Bogota").strftime("%B %-d, %Y – %H:%M")
  end

  def resolved_at_display_time
    return unless model.resolved_at.present?

    model.resolved_at.in_time_zone("America/Bogota").strftime("%B %-d, %Y – %H:%M")
  end
end
