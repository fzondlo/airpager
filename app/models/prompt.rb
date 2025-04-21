class Prompt
  def self.ensure_conversation_needs_reply_from_team(messages)
    <<~PROMPT
      Return only TRUE or FALSE: does our team need to reply to the guest?

      Conversation:
      #{messages.map do |message|
        "[#{message[:sender_role] || 'guest'} - #{message[:sender_full_name]}]: #{message[:content]}"
      end.join("\n")}
    PROMPT
  end
end
