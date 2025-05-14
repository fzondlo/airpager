module Waapi
  class Gateway
    include HTTParty
    base_uri "https://waapi.app"

    def initialize(api_token)
      self.class.headers "Authorization" => "Bearer #{api_token}",
                         "Content-Type" => "application/json",
                         "Accept" => "application/json"
    end

    def send_message(message, chat_id)
      self.class.post(
        "/api/v1/instances/#{instance_id}/client/action/send-message",
        body: {
          chatId: chat_id,
          message: message,
        }.to_json
      )
    end

    def register_webhook(endpoint)
      self.class.put(
        "/api/v1/instances/#{instance_id}",
        body: {
          "webhook": {
            "url": endpoint,
            "events": [ "message" ]
          }
        }).to_json
    end

    def instance_id
      @instance_id ||= self.class.get(
        "/api/v1/instances"
      )["instances"][0]["id"]
    end

    def find_all_chats
      self.class.post(
        "/api/v1/instances/#{instance_id}/client/action/get-chats",
        body: {
          "offset": 0,
          "limit": 500
        }
      )
    end
  end
end
