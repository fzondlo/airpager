class PromptTest < ActiveSupport::TestCase
  def test_ensure_conversation_needs_reply_from_team
    messages = [
      { sender_role: nil, sender_type: "guest", sender_full_name: "Alice", content: "Hi, I have a question about my booking." },
      { sender_role: "host", sender_type: "host", sender_full_name: "Frank", content: "Sure, what would you like to know?" },
      { sender_role: "teammate", sender_type: "host", sender_full_name: "Bob", content: "Can I also help?" },
      { sender_role: nil, sender_type: "guest", sender_full_name: "Alice", content: "What time can I check-in tomorrow?" }
    ]

    expected_prompt = <<~TEXT
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
      [guest - Alice]: Hi, I have a question about my booking.
      [host - Frank]: Sure, what would you like to know?
      [host - Bob]: Can I also help?
      [guest - Alice]: What time can I check-in tomorrow?

      Please classify as P1, P2, or P3 using this JSON format and substitute the values.
      Use the format of the example values below. No markdown,
      no code fences, no explanation, just this json response object.

      {
        "urgency": "P1"
      }
    TEXT

    actual_prompt = Prompt.ensure_conversation_needs_reply_from_team(messages)

    assert_equal expected_prompt.strip, actual_prompt.strip
  end
end
