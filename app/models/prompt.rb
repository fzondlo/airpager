class Prompt
  def self.ensure_conversation_needs_reply_from_team(messages)
    <<~PROMPT
      Pretend that you are an Airbnb host and a customer is messaging you through the platform.
      Below you will find the message exchange.

      I would like you to clasify the urgency of the guest's request as either:
      P1, P2, P3, or NO_RESPONSE_REQUIRED

      Here are example of different each P level. Please use this to as a guide and take your best
      guess based on the conversation below. If you are not sure, better to err on the side of caution.
      So for example if it's something that you think is between a P3 and P2, then better to go with
      a P2.

      P1:
        - Something urgent that requires an immediate response.
        - Guest unable to enter the apartment.
        - Stuck in the elevator.
        - The access code isn’t working to the buliding or the apartment and the guest is locked out.

      P2:
        - Power outage.
        - Water heater is not working.

      P3:
        - Not an urgent problem
        - A request for a late checkout or early checkin
        - A request for a refund or a discount
        - A request to schedule a complimentary cleaning
        - Asking for a recommendation, eg: restaurant or places to visit.

      NO_RESPONSE_REQUIRED:
        - When conversation has come to a natural conclusion.
        - When the guest is just saying thank you, or you're welcome.
        - When they send passports or identification documents.

      Here is the Conversation:
      #{messages.map do |message|
        "[#{message[:sender_type]} - #{message[:sender_full_name]}]: #{message[:content]}"
      end.join("\n")}

      Please classify as P1, P2, or P3 using this JSON format and substitute the values.
      Use the format of the example values below. No markdown,
      no code fences, no explanation, just this json response object.

      {
        "urgency": "P1"
      }
    PROMPT
  end

  def self.process_receipt
    <<~PROMPT
      This image is a receipt. I would like you to pull out the following elements:

      - Date of transaction (as date)
      - Cost
      - Currency (will either be USD or COP)
      - Description of what was purchased in spanish, no more than 15 words. Try to summarize all the items that were purchased as part of the reciept.
      - Vendor name (can be your best guess)

      And then using the date and the cost do a lookup to find the missing currency, if you have USD then convert to COP using the exchange rate on the date of the transaction. And if you have COP then convert to USD.

      Please be extra sure and spend extra time if needed to do multiple looks to confirm the conversion is accurate for the day of the transaction as I will charge clients this amount.

      Please respond using this JSON format and substitute the values, and use the format of the example values below. No markdown, no code fences, no explanation, just this json response object.

      {
        "date": "30.1.2025",
        "cost_in_usd": 12.44,
        "cost_in_cop": 49522,
        "description": "Table and chairs",
        "vendor_name": "Home Center"
      }
    PROMPT
  end

  def self.bot_reply(auto_replies, fallback_message = "Sorry, I don't have an answer for that.")
    <<~PROMPT
      You are a helpful Airbnb co-host assistant. Below is a list of predefined auto replies based on common guest questions or phrases.

      Your task is to:
      - Interpret the guest's message.
      - If the meaning closely matches one of the triggers below, respond with the corresponding reply.
      - If the message does not match the meaning of any trigger, or if the list is empty, respond **exactly** with: "#{fallback_message}"

      Only respond with replies listed below. Do not generate your own reply.

      Predefined replies:
      #{auto_replies.map { |auto_reply| "- If the guest says something like: \"#{auto_reply.trigger}\", reply with: \"#{auto_reply.reply}\"" }.join("\n")}

      Do not invent new answers. Only use the replies provided or return the fallback message as instructed.
    PROMPT
  end
end
