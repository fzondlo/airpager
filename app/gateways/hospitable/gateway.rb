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
     response = self.class.get("/v2/properties/")
     Response::FindProperties.new(response)
    end

    def find_reservations(property_ids)
      properties_query = property_ids.join("&properties[]=")
      response = self.class.get(
        "/v2/reservations/?properties[]=#{properties_query}&include=guest,properties" +
        "&start_date=#{2.month.ago.to_date}&end_date=#{2.month.from_now.to_date}" +
        "&per_page=100"
      )
      Response::FindReservations.new(response)
    end

    def find_reservation(reservation_id)
      response = self.class.get("/v2/reservations/#{reservation_id}?include=properties")
      Response::FindReservation.new(response)
    end

    def find_inquiry(inquiry_id)
      response = self.class.get("/v2/inquiries/#{inquiry_id}?include=properties")
      Response::FindInquiry.new(response)
    end

    # TODO: Clickup segment? What is that? I don't think we are using it anyway
    # Might be good to delete.
    def find_reservation_messages(reservation_id)
      response = self.class.get("/v2/clickup/#{reservation_id}/messages")
      Response::FindReservationMessages.new(response)
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
