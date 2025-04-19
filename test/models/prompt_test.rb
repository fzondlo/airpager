class PromptTest < ActiveSupport::TestCase
  def test_ensure_conversation_needs_reply_from_team
    messages = [
      { sender_role: nil, sender_full_name: 'Alice', content: 'Hi, I have a question about my booking.' },
      { sender_role: 'host', sender_full_name: 'Frank', content: 'Sure, what would you like to know?' },
      { sender_role: 'teammate', sender_full_name: 'Bob', content: 'Can I also help?' }
    ]

    expected_prompt = <<~TEXT
      Return only TRUE or FALSE: does our team need to reply to the guest?

      Conversation:
      [ - Alice]: Hi, I have a question about my booking.
      [host - Frank]: Sure, what would you like to know?
      [teammate - Bob]: Can I also help?
    TEXT

    actual_prompt = Prompt.ensure_conversation_needs_reply_from_team(messages)

    assert_equal expected_prompt.strip, actual_prompt.strip
  end
end
