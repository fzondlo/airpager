module Hospitable
  class BogusGateway
    def initialize(*)
      # no-op
    end

    def find_properties
      # no-op
    end

    def find_reservations(property_ids)
      # no-op
    end


    def find_reservation_messages(reservation_id)
      # no-op
    end

    def send_message_for_inquiry(conversation_id, message)
      # no-op
    end

    def send_message_for_reservation(reservation_id, message)
      # no-op
    end
  end
end
