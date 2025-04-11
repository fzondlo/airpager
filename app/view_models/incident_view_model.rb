class IncidentViewModel < ApplicationViewModel
  def badge_status_class
    return 'bg-gray-200 text-gray-800' if model.status == 'created'
    return 'bg-yellow-300 text-yellow-800' if model.status == 'alerted'
    return 'bg-green-200 text-green-800' if model.status == 'resolved'
  end

  def description
    return '💬 Pending team reply' if model.kind == 'pending_reply'
  end

  def reason
    case model.kind
    when 'pending_reply'
      "This incident was triggered because a client sent a message and hasn't received a reply yet."
    else
      "No reason available for this type of incident."
    end
  end

  def how_to_resolve
    case model.kind
    when 'pending_reply'
      "You can solve this incident by accessing the conversation and reply to the customer: <a class=\"text-blue-500\" href=\"#{hospitable_thread_url(model.source_details["conversation_id"])}\">#{hospitable_thread_url(model.source_details["conversation_id"])}</a>".html_safe
    else
      "No ways available to solve this type of incident."
    end
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

  private

  def hospitable_thread_url(conversation_id)
    "https://my.hospitable.com/inbox/thread/" << conversation_id
  end
end
