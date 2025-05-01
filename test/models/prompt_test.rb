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
      Below are the past message exchanges.
      After this last comment, do you think that the host needs to respond?
      And in this context, in cases of acknowledgment or thank you, it is not necessary to respond.
      You would want to respond only if the guest has a question that needs to be answered, is unhappy with something, or if there is a similar situation where not responding would not be acceptable from a hospitality point of view.

      Please only respond with either "TRUE" (as in, a response is necessary), or "FALSE" when a response is not necessary.

      Conversation:
      [guest - Alice]: Hi, I have a question about my booking.
      [host - Frank]: Sure, what would you like to know?
      [host - Bob]: Can I also help?
      [guest - Alice]: What time can I check-in tomorrow?
    TEXT

    actual_prompt = Prompt.ensure_conversation_needs_reply_from_team(messages)

    assert_equal expected_prompt.strip, actual_prompt.strip
  end
end
