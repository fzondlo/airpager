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

  def self.process_receipt
    <<~PROMPT
      This image is a reciept. I would like you to pull out the following elements:

      - Date of transaction (as date)
      - Cost
      - Currency (will either be USD or COP)
      - Description of what was purchased in spanish, no more than 15 words. Try to summarize all the items that were purchased as part of the reciept.

      And then using the date and the cost do a lookup to find the missing currency, if you have USD then convert to COP using the exchange rate on the date of the transaction. And if you have COP then convert to USD.

      Please respond using this JSON format and substitute the values, and use the format of the example values below. No markdown, no code fences, no explanation, just this json response object.

      {
        "date": "30/1/2025",
        "cost_in_usd": 12.44,
        "cost_in_cop": 49522,
        "description": "Table and chairs",
      }
    PROMPT
  end
end
