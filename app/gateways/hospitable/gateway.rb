class Hospitable
  class Gateway
    include HTTParty
    base_uri 'https://public.api.hospitable.com'

    def initialize(api_token)
      self.class.headers 'Authorization' => "Bearer #{api_token}",
                         'Content-Type' => 'application/json',
                         'Accept' => 'application/json'
    end

    def properties
      self.class.get("/v2/properties/")
    end

    def reservations
      self.class.get("/v2/reservations/?properties[]=2dffe1d8-960d-4b16-8521-7f3628d9ec33")
    end

    def messages(reservation_id)
      self.class.get("/v2/reservations/#{reservation_id}/messages")
    end
  end
end
