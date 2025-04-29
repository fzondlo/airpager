class PromptTest < ActiveSupport::TestCase
  def test_ensure_conversation_needs_reply_from_team
    messages = [
      { sender_role: nil, sender_type: "guest", sender_full_name: "Alice", content: "Hi, I have a question about my booking." },
      { sender_role: "host", sender_type: "host", sender_full_name: "Frank", content: "Sure, what would you like to know?" },
      { sender_role: "teammate", sender_type: "host", sender_full_name: "Bob", content: "Can I also help?" }
    ]

    expected_prompt = <<~TEXT
      We need to determine if our team needs to reply to the last message from the guest.

      Please return ONLY "TRUE" or "FALSE" based on whether the team needs to respond to the last message.

      - Return "TRUE" if a response is needed.
      - Return "FALSE" if no response is needed.

      Conversation:
      [guest - Alice]: Hi, I have a question about my booking.
      [host - Frank]: Sure, what would you like to know?
      [host - Bob]: Can I also help?
    TEXT

    actual_prompt = Prompt.ensure_conversation_needs_reply_from_team(messages)

    assert_equal expected_prompt.strip, actual_prompt.strip
  end
end
