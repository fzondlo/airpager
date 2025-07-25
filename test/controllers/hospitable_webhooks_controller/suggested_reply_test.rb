require "test_helper"

class HospitableWebhooksController
  class SuggestedReplyTest < ActiveSupport::TestCase
    def setup
      @message = create_message(content: "What is the wifi code?")
      @property = create_property
      @auto_reply = create_auto_reply(trigger: "wifi code?", reply: "The Wi-Fi code is welcomehome", properties: [ @property ], live_enabled: true)
    end

    def test_logs_message_with_suggested_reply
      expected_log = <<~TEXT
        New Message from jeremie ges:
        What is the wifi code?

        -----

        Suggested Reply:
        ##{@auto_reply.id} – The Wi-Fi code is welcomehome

        -----

        Debug:
        This suggested reply would have been sent (live enabled)
      TEXT

      OpenAi::BogusGateway.any_instance.stubs(:find_auto_reply).returns(
        stub(success?: true, auto_reply_id: @auto_reply.id.to_s)
      )

      PropertyIdentifier.any_instance.stubs(:resolve).returns(@property)

      Waapi::BogusGateway.any_instance.expects(:send_message).with do |message|
        assert_equal expected_log, message
      end.once

      SuggestedReply.new(@message).log

      usage = AutoReplyUsage.last
      assert_equal @auto_reply.reply, usage.suggested_reply
      assert_equal @message.id, usage.message_trigger_id.to_i
      assert_equal @message.conversation_id, usage.conversation_id
      assert_equal @auto_reply.id, usage.auto_reply_id
    end

    def test_logs_debug_skipping_when_auto_reply_already_used
      AutoReplyUsage.create!(conversation_id: @message.conversation_id, auto_reply: @auto_reply, usage_type: "live")

      expected_log = <<~TEXT
        New Message from jeremie ges:
        What is the wifi code?

        -----

        Suggested Reply:
        ##{@auto_reply.id} – The Wi-Fi code is welcomehome

        -----

        Debug:
        This suggested reply has already been used in the conversation, skipping ...
      TEXT

      OpenAi::BogusGateway.any_instance.stubs(:find_auto_reply).returns(
        stub(success?: true, auto_reply_id: @auto_reply.id.to_s)
      )

      PropertyIdentifier.any_instance.stubs(:resolve).returns(@property)

      Waapi::BogusGateway.any_instance.expects(:send_message).with do |message|
        assert_equal expected_log, message
      end.once

      SuggestedReply.new(@message).log
    end

    def test_logs_fallback_message_when_no_auto_reply_found
      expected_log = <<~TEXT
        New Message from jeremie ges:
        What is the wifi code?

        -----

        Suggested Reply:
        Sorry, I don't have an answer for that.

        -----

        Debug:
        Suggested reply not found.
      TEXT

      OpenAi::BogusGateway.any_instance.stubs(:find_auto_reply).returns(
        stub(success?: true, auto_reply_id: nil)
      )

      PropertyIdentifier.any_instance.stubs(:resolve).returns(@property)

      Waapi::BogusGateway.any_instance.expects(:send_message).with do |message|
        assert_equal expected_log, message
      end.once

      SuggestedReply.new(@message).log
    end
  end
end
