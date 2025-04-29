class Prompt
  def self.ensure_conversation_needs_reply_from_team(messages)
    <<~PROMPT
      We need to determine if our team needs to reply to the last message from the guest.

      Please return ONLY "TRUE" or "FALSE" based on whether the team needs to respond to the last message.

      - Return "TRUE" if a response is needed.
      - Return "FALSE" if no response is needed.

      Conversation:
      #{messages.map do |message|
        "[#{message[:sender_type]} - #{message[:sender_full_name]}]: #{message[:content]}"
      end.join("\n")}
    PROMPT
  end
end
