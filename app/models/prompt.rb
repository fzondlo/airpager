class Prompt
  def self.ensure_conversation_needs_reply_from_team(messages)
    <<~PROMPT
      Pretend that you are an Airbnb host and a customer is messaging you through the platform.
      Below are the past message exchanges.
      After this last comment, do you think that the host needs to respond?
      And in this context, in cases of acknowledgment or thank you, it is not necessary to respond.
      You would want to respond only if the guest has a question that needs to be answered, is unhappy with something, or if there is a similar situation where not responding would not be acceptable from a hospitality point of view.

      Please only respond with either "TRUE" (as in, a response is necessary), or "FALSE" when a response is not necessary.

      Conversation:
      #{messages.map do |message|
        "[#{message[:sender_type]} - #{message[:sender_full_name]}]: #{message[:content]}"
      end.join("\n")}
    PROMPT
  end
end
