require "test_helper"
require "ostruct"

class PropertyIdentifierTest < ActiveSupport::TestCase
  def setup
    @property = Property.create!(name: "Test", slug: "test", clickup_custom_field_id: "abc", hospitable_id: "prop-123")
  end

  def test_resolves_property_id_from_reservation
    binding.pry

    message = MessageViewModel.wrap(
      Message.create!(
        reservation_id: "res-123",
        conversation_id: "conv-123",
      )
    )

    id = HospitableWebhooksController::PropertyIdentifier.new(message).resolve

    assert_equal @property.id, id
  end

  # def test_returns_nil_on_failed_gateway_response
  #   message = OpenStruct.new(from_reservation?: true, from_inquiry?: false, reservation_id: "res-456")

  #   Hospitable.gateway.expects(:find_reservation).with("res-456").returns(OpenStruct.new(success?: false))

  #   result = HospitableWebhooksController::PropertyIdentifier.new(message).resolve
  #   assert_nil result
  # end

  # def test_resolves_property_id_from_inquiry
  #   message = OpenStruct.new(
  #     from_reservation?: false,
  #     from_inquiry?: true,
  #     reservation_id: nil,
  #     conversation_id: "conv-456"
  #   )

  #   gateway_response = OpenStruct.new(
  #     success?: true,
  #     property: { "id" => "prop-123" }
  #   )

  #   Hospitable.gateway.expects(:find_inquiry).with("conv-456").returns(gateway_response)

  #   id = HospitableWebhooksController::PropertyIdentifier.new(message).resolve
  #   assert_equal @property.id, id
  # end

  # def test_returns_nil_when_no_property_id
  #   message = OpenStruct.new(from_reservation?: false, from_inquiry?: false)
  #   id = HospitableWebhooksController::PropertyIdentifier.new(message).resolve
  #   assert_nil id
  # end
end
