require "test_helper"

class HospitableWebhooksController
  class MessageUrgencyTest < ActiveSupport::TestCase
    def setup
      @conversation_id = 123
      @reservation_id = 456
      @posted_at = Time.current
      @content = "Hello"

      @message = Message.create!(
        conversation_id: @conversation_id,
        reservation_id: @reservation_id,
        posted_at: @posted_at,
        content: @content
      )

      Prompt.stubs(:ensure_conversation_needs_reply_from_team).returns("prompt")
      OpenAiRequest.stubs(:create)
    end

    def subject
      MessageUrgency.new(@message)
    end

    test "returns :P0 when message is a lead (reservation_id is nil)" do
      @message.update!(reservation_id: nil)
      assert_equal :P0, subject.urgency
    end

    test "returns :P0 when message is likely an image (content is nil)" do
      @message.update!(content: nil)
      assert_equal :P0, subject.urgency
    end

    test "returns :P1 when OpenAI responds with a valid urgency" do
      fake_response = stub(success?: true, answer: "{\n  \"urgency\": \"P2\"\n}", body: {})
      ::OpenAi.stubs(:gateway).returns(stub(chat: fake_response))
      assert_equal :P2, subject.urgency
    end

    test "logs a warning and returns :P1 when OpenAI responds with unknown urgency" do
      fake_response = stub(success?: true, answer: "{\n  \"urgency\": \"something_crazy\"\n}", body: {})
      ::OpenAi.stubs(:gateway).returns(stub(chat: fake_response))
      Rails.logger.expects(:warn).with { |arg| arg.include?("ChatGPT returned an unknown urgency:") }
      assert_equal :P1, subject.urgency
    end

    test "returns :P1 when OpenAI does not succeed" do
      fake_response = stub(success?: false)
      ::OpenAi.stubs(:gateway).returns(stub(chat: fake_response))
      assert_equal :P1, subject.urgency
    end
  end
end
