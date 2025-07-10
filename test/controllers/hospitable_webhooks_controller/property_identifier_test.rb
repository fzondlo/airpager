require "test_helper"

class PropertyIdentifierTest < ActiveSupport::TestCase
  # TODO: We could "clean up" a la Frank / rspec style with a subject method / update the message on each tests instead
  def setup
    @property = Property.create!(name: "Test", slug: "test", hospitable_id: "prop-123", clickup_custom_field_id: "abc")
  end

  def test_resolves_property_id_from_reservation
    message = Message.create!(
      reservation_id: "res-123",
      conversation_id: "conv-123"
    )

    id = HospitableWebhooksController::PropertyIdentifier.new(message).resolve

    assert_equal @property.id, id
  end

  def test_resolves_property_id_from_inquiry
    message = Message.create!(
      reservation_id: nil,
      conversation_id: "inq-123"
    )

    id = HospitableWebhooksController::PropertyIdentifier.new(message).resolve

    assert_equal @property.id, id
  end

  def test_resolves_nil_when_no_matching_properties
    @property.destroy

    message = Message.create!(
      reservation_id: nil,
      conversation_id: "inq-123"
    )

    id = HospitableWebhooksController::PropertyIdentifier.new(message).resolve
    assert_nil id
  end

  def test_resolves_nil_on_failed_gateway_response
    message = Message.create!(
      reservation_id: nil,
      conversation_id: "inq-fail"
    )

    id = HospitableWebhooksController::PropertyIdentifier.new(message).resolve
    assert_nil id

    message = Message.create!(
      reservation_id: "res-fail",
      conversation_id: "conv-123"
    )

    id = HospitableWebhooksController::PropertyIdentifier.new(message).resolve
    assert_nil id
  end
end
