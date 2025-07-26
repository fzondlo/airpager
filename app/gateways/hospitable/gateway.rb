module Hospitable
  class Gateway
    include HTTParty
    base_uri "https://public.api.hospitable.com"

    def initialize(api_token)
      self.class.headers "Authorization" => "Bearer #{api_token}",
                         "Content-Type" => "application/json",
                         "Accept" => "application/json"
    end

    def find_properties
     response = self.class.get("/v2/properties/?per_page=100")
     Response::FindProperties.new(response)
    end

    def find_reservations(property_ids)
      page = 1
      all_reservations = []
      properties_query = property_ids.join("&properties[]=")

      loop do
        response = self.class.get(
          "/v2/reservations/?properties[]=#{properties_query}" \
          "&include=guest,properties" \
          "&start_date=#{2.months.ago.to_date}" \
          "&end_date=#{2.months.from_now.to_date}" \
          "&per_page=100&page=#{page}"
        )
        parsed_response = Response::FindReservations.new(response)
        all_reservations.concat(parsed_response.reservations)

        last_page = response["meta"]["last_page"]
        break if page >= last_page

        page += 1
      end

      all_reservations
    end

    def find_reservation(reservation_id)
      response = self.class.get("/v2/reservations/#{reservation_id}?include=properties")
      Response::FindReservation.new(response)
    end

    def find_inquiry(inquiry_id)
      response = self.class.get("/v2/inquiries/#{inquiry_id}?include=properties")
      Response::FindInquiry.new(response)
    end

    def send_message_for_reservation(reservation_id, message)
      # response = self.class.post("/v2/reservations/#{reservation_id}/messages", body: {
      #   body: message
      # }.to_json)
      # Response::SendMessageForReservation.new(response)
    end

    def send_message_for_inquiry(conversation_id, message)
      # response = self.class.post("/v2/inquiries/#{conversation_id}/messages", body: {
      #   body: message
      # }.to_json)
      # Response::SendMessageForInquiry.new(response)
    end
  end
end
