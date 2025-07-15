require "test_helper"

class AutoReplyIdentifierTest < ActiveSupport::TestCase
  def test_resolve_return_nil_when_no_auto_replies
    message = Message.create!(conversation_id: "conv-123")

    subject = AutoReplyIdentifier.new(message: message, property_id: "prop-123").resolve

    assert_nil subject
  end

  def test_resolve_returns_auto_reply_when_id_is_valid
    message = Message.create!(conversation_id: "conv-123")
    property = Property.create!(name: "Test", slug: "test", hospitable_id: "prop-123", clickup_custom_field_id: "abc")
    auto_reply = AutoReply.create!(trigger: "hello", reply: "Hi!", properties: [property])

    binding.pry

    OpenAi::BogusGateway.any_instance.stubs(:find_auto_reply).returns(
      stub(success?: true, auto_reply_id: "#{auto_reply.id}")
    )

    subject = AutoReplyIdentifier.new(message: message, property_id: property.id).resolve

    assert_equal subject, auto_reply
  end
end


# require "test_helper"

# class AutoReplyIdentifierTest < ActiveSupport::TestCase
#   def setup
#     @message = Message.create!(conversation_id: "conv-123")
#     @property = Property.create!(
#       name: "Test",
#       slug: "test",
#       hospitable_id: "prop-123",
#       clickup_custom_field_id: "abc"
#     )
#     @auto_reply = AutoReply.create!(
#       trigger: "hello",
#       reply: "Hi!",
#       properties: [@property]
#     )
#   end

#   def test_resolve_return_nil_when_no_auto_replies
#     subject = AutoReplyIdentifier.new(message: @message, property_id: "unknown").resolve
#     assert_nil subject
#   end

#   def test_resolve_returns_auto_reply_when_id_is_valid
#     OpenAi::BogusGateway.any_instance.stubs(:find_auto_reply).returns(
#       stub(success?: true, auto_reply_id: @auto_reply.id.to_s)
#     )

#     subject = AutoReplyIdentifier.new(message: @message, property_id: @property.id).resolve

#     assert_equal @auto_reply, subject
#   end

#   def test_resolve_returns_nil_when_openai_fails
#     OpenAi::BogusGateway.any_instance.stubs(:find_auto_reply).returns(
#       stub(success?: false, auto_reply_id: nil)
#     )

#     subject = AutoReplyIdentifier.new(message: @message, property_id: @property.id).resolve

#     assert_nil subject
#   end

#   def test_resolve_returns_nil_when_openai_returns_nil_id
#     OpenAi::BogusGateway.any_instance.stubs(:find_auto_reply).returns(
#       stub(success?: true, auto_reply_id: nil)
#     )

#     subject = AutoReplyIdentifier.new(message: @message, property_id: @property.id).resolve

#     assert_nil subject
#   end

#   def test_resolve_returns_nil_when_openai_returns_invalid_id
#     # Assume this ID doesn't exist in DB
#     OpenAi::BogusGateway.any_instance.stubs(:find_auto_reply).returns(
#       stub(success?: true, auto_reply_id: "99999")
#     )

#     assert_raises(ActiveRecord::RecordNotFound) do
#       AutoReplyIdentifier.new(message: @message, property_id: @property.id).resolve
#     end
#   end

#   def test_resolve_with_blank_property_id_returns_nil
#     subject = AutoReplyIdentifier.new(message: @message, property_id: nil).resolve
#     assert_nil subject
#   end

#   def test_auto_replies_only_returns_replies_for_property
#     other_property = Property.create!(name: "Other", slug: "other", hospitable_id: "p2", clickup_custom_field_id: "def")
#     unrelated_reply = AutoReply.create!(trigger: "bye", reply: "Bye!", properties: [other_property])

#     OpenAi::BogusGateway.any_instance.stubs(:find_auto_reply).returns(
#       stub(success?: true, auto_reply_id: unrelated_reply.id.to_s)
#     )

#     assert_raises(ActiveRecord::RecordNotFound) do
#       AutoReplyIdentifier.new(message: @message, property_id: @property.id).resolve
#     end
#   end
# end
