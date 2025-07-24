require "test_helper"

class AutoReplyIdentifierTest < ActiveSupport::TestCase
  def setup
    @message = create_message
    @property = create_property
    @auto_reply = create_auto_reply(properties: [ @property ])
  end

  def test_resolve_returns_auto_reply_when_id_is_valid
    OpenAi::BogusGateway.any_instance.stubs(:find_auto_reply).returns(
      stub(success?: true, auto_reply_id: @auto_reply.id.to_s)
    )

    subject = AutoReplyIdentifier.new(message: @message, property: @property).resolve

    assert_equal subject, @auto_reply
  end

  def test_resolve_returns_nil_when_no_auto_replies
    @auto_reply.destroy

    subject = AutoReplyIdentifier.new(message: @message, property: @property).resolve
    assert_nil subject
  end

  def test_resolve_returns_nil_when_openai_fails
    OpenAi::BogusGateway.any_instance.stubs(:find_auto_reply).returns(
      stub(success?: false, auto_reply_id: nil)
    )

    subject = AutoReplyIdentifier.new(message: @message, property: @property).resolve
    assert_nil subject
  end

  def test_resolve_returns_nil_when_openai_returns_invalid_id
    OpenAi::BogusGateway.any_instance.stubs(:find_auto_reply).returns(
      stub(success?: true, auto_reply_id: "999")
    )

    subject = AutoReplyIdentifier.new(message: @message, property: @property).resolve
    assert_nil subject
  end

  def test_resolve_with_blank_property_returns_nil
    subject = AutoReplyIdentifier.new(message: @message, property: nil).resolve
    assert_nil subject
  end

  def test_resolve_only_returns_replies_for_property
    other_property = create_property(name: "Other property", clickup_custom_field_id: "cf-other-123", hospitable_id: "hospitable-other-123")
    other_auto_reply = AutoReply.create!(trigger: "bye", reply: "Bye!", properties: [ other_property ])

    OpenAi::BogusGateway.any_instance.stubs(:find_auto_reply).returns(
      stub(success?: true, auto_reply_id: other_auto_reply.id.to_s)
    )

    subject = AutoReplyIdentifier.new(message: @message, property: @property).resolve
    assert_nil subject
  end

  def test_resolve_does_not_return_wrong_context_auto_reply
    @message.update!(reservation_id: nil)
    @auto_reply.update!(trigger_context: "reservation")

    OpenAi::BogusGateway.any_instance.stubs(:find_auto_reply).returns(
      stub(success?: true, auto_reply_id: @auto_reply.id.to_s)
    )

    subject = AutoReplyIdentifier.new(message: @message, property: @property).resolve
    assert_nil subject
  end
end
