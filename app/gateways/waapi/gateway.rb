module Waapi
  class Gateway
    include HTTParty
    base_uri "https://api.openai.com/v1"

    def initialize(api_token)
      self.class.headers "Authorization" => "Bearer #{api_token}",
                         "Content-Type" => "application/json",
                         "Accept" => "application/json"
    end

    def chat
    end
  end
end
