module Hospitable
  class BogusGateway
    def initialize(*)
      # no-op
    end

    def find_properties
      # no-op
    end

    def find_reservation(reservation_id)
      body =
        if reservation_id == "res-123"
          { "data" => { "properties" => [ { "id" => "prop-123" } ] } }
        elsif reservation_id == "res-fail"
          nil
        else
          { "data" => { "properties" => [ { "id" => "unknown" } ] } }
        end

      response = body.nil? ? RawResponse.new({}, 500) : RawResponse.new(body)
      Response::FindReservation.new(response)
    end

    def find_inquiry(inquiry_id)
      body =
        if inquiry_id == "inq-123"
          { "data" => { "properties" => { "id" => "prop-123" } } }
        elsif inquiry_id == "inq-fail"
          nil
        else
          { "data" => { "properties" => { "id" => "unknown" } } }
        end

      response = body.nil? ? RawResponse.new({}, 500) : RawResponse.new(body)
      Response::FindInquiry.new(response)
    end

    def find_reservations(property_ids)
      # no-op
    end

    def send_message_for_inquiry(conversation_id, message)
       # no-op
     end

     def send_message_for_reservation(reservation_id, message)
       # no-op
     end
  end

  class RawResponse
    attr_reader :parsed_response, :code

    def initialize(body, code = 200)
      @parsed_response = body
      @code = code
    end

    def success?
      code == 200
    end

    def body
      parsed_response
    end
  end
end
