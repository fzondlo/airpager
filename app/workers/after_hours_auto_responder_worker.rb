class AfterHoursAutoResponderWorker
  include Sidekiq::Worker

  def perform(reservation_id)
    auto_respond_text = <<~TEXT
      Hi there, thanks for reaching out!

      You’ve caught us outside of our usual hours, but no worries — someone from our team will get back to you first thing in the morning.

      We appreciate your patience and look forward to helping you soon.
    TEXT

    # Most recent message for reservation
    most_recent_message = MessageViewModel.wrap(
      Message.where(reservation_id: reservation_id).order(posted_at: :desc).first
    )

    unless most_recent_message.present?
      return
    end

    if most_recent_message.from_guest?
      # Auto-respond
      puts "For reservation_id: #{reservation_id}"
      puts auto_respond_text
    end
  end
end
