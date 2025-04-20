module OpenAi
  class Gateway
    include HTTParty
    base_uri 'https://api.openai.com/v1'

    def initialize(api_token)
      self.class.headers 'Authorization' => "Bearer #{api_token}",
                         'Content-Type' => 'application/json',
                         'Accept' => 'application/json'
    end

    def chat(prompt, model: "gpt-4.1-nano")
      body = {
        model: model,
        messages: [
          { role: "user", content: prompt }
        ]
      }

      response = self.class.post("/chat/completions", body: body.to_json)
      Response::Chat.new(response)
    end
  end
end
