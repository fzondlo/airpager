module Allquiet
  class Gateway
    include HTTParty
    base_uri "https://allquiet.app/api"

    attr_reader :webhook_token

    def initialize(webhook_token)
      @webhook_token = webhook_token
    end

    def create_incident
     response = self.class.post("/webhook/#{webhook_token}")
     Response::CreateIncident.new(response)
    end
  end
end
