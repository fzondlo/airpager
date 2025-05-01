module Allquiet
  class Gateway
    include HTTParty
    base_uri "https://allquiet.app/api"

    attr_reader :webhook_token

    def initialize(webhook_token)
      @webhook_token = webhook_token
    end

    def create_incident
     response = self.class.get("/webhook/#{webhook_token}", query: {
        your_alert_id: "1f4b15b2",
        alert_name: "AirBnb Mensaje",
        status: "firing",
        level: "high",
        alert_desc: "AirBnb Mensaje"
      })

     Response::CreateIncident.new(response)
    end
  end
end
