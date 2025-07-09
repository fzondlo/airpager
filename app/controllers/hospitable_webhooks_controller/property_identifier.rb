class HospitableWebhooksController
  class PropertyIdentifier
    attr_reader :message

    def initialize(message)
      @message = message
    end

    def resolve
      return unless hospitable_property_id.present?

      binding.pry

      Property.find_by(hospitable_id: hospitable_property_id)&.id
    end

    private

    def hospitable_property_id
      return unless response.present?
      return unless response.success?

      response.property["id"]
    end


    def response
      @response ||= begin
        if message.from_reservation?
          Hospitable.gateway.find_reservation(message.reservation_id)
        elsif message.from_inquiry?
          Hospitable.gateway.find_inquiry(message.conversation_id)
        end
      end
    end
  end
end
