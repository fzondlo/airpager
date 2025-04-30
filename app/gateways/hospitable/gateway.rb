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
      properties_query = property_ids.join('&properties[]=')
      response = self.class.get(
        "/v2/reservations/?properties[]=#{properties_query}&include=guest,properties" +
        "&start_date=#{1.month.ago.to_date}&end_date=#{2.month.from_now.to_date}" +
        "&per_page=100"
      )
      Response::FindReservations.new(response)
    end

    def find_reservation_messages(reservation_id)
      response = self.class.get("/v2/reservations/#{reservation_id}/messages")
      Response::FindReservationMessages.new(response)
    end
  end
end
