class HospitableWebhooksController
  class PropertyIdentifier
    attr_reader :message

    def initialize(message)
      @message = message
    end

    def resolve
      return unless hospitable_property_id.present?

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
        if from_reservation?(message)
          Hospitable.gateway.find_reservation(message.reservation_id)
        elsif from_inquiry?(message)
          Hospitable.gateway.find_inquiry(message.conversation_id)
        end
      end
    end

    def from_reservation?(message)
      message.reservation_id.present?
    end

    def from_inquiry?(message)
      !from_reservation?(message) && message.conversation_id.present?
    end
  end
end
