class IncidentViewModel < ApplicationViewModel
  delegate :description, :reason, :how_to_resolve, to: :kind

  def kind
    @kind ||= case model.kind
    when "pending_reply"
     PendingReplyIncidentKind.new(model)
    else
     BaseIncidentKind.new(model)
    end
  end

  def badge_status_class
    return "bg-gray-200 text-gray-800" if model.status == "created"
    return "bg-yellow-300 text-yellow-800" if model.status == "alerted"
    "bg-green-200 text-green-800" if model.status == "resolved"
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

class BaseIncidentKind
  attr_reader :model

  def initialize(model)
    @model = model
  end

  def description
    ""
  end

  def reason
    "No reason available for this type of incident."
  end

  def how_to_resolve
    "No resolution instructions available."
  end

  def conversation_messages
    []
  end
end

class PendingReplyIncidentKind < BaseIncidentKind
  def description
    "💬 Pending team reply"
  end

  def reason
    "This incident was triggered because a client sent a message and hasn't received a reply yet."
  end

  def how_to_resolve
    "You can solve this incident by accessing the conversation and reply to the customer: #{conversation_link}".html_safe
  end

  def conversation_messages
    @conversation_messages ||= MessageViewModel.wrap(
      Message.where(conversation_id: conversation_id, reservation_id: reservation_id).order(posted_at: :desc).limit(5).all.reverse
    )
  end

  def conversation_id
    model.source_details["conversation_id"]
  end

  def reservation_id
    model.source_details["reservation_id"]
  end

  private

  def conversation_link
    "<a href='#{hospitable_thread_url}' class='text-blue-500'>#{hospitable_thread_url}</a>"
  end

  def hospitable_thread_url
    "https://my.hospitable.com/inbox/thread/" << conversation_id
  end
end
