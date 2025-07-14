module OpenAi
  class Gateway
    include HTTParty
    base_uri "https://api.openai.com/v1"

    def initialize(api_token)
      self.class.headers "Authorization" => "Bearer #{api_token}",
                         "Content-Type" => "application/json",
                         "Accept" => "application/json"
    end

    def chat(prompt, model: "gpt-4.1-nano")
      body = {
        model: model,
        messages: [
          { role: "user", content: prompt }
        ]
      }
      response = self.class.post(
        "/chat/completions",
        body: body.to_json
      )

      puts "Prompt: #{prompt}"
      puts "Response: #{response.to_json}"

      Response::Chat.new(response)
    end

    def process_receipt(prompt, receipt, model: "o4-mini")
      body = {
        model: model,
        messages: [
          { role: "user", content: [
            {
              "type": "text",
              "text": prompt
            },
            {
              "type": "image_url",
              "image_url": { "url": "data:image/jpeg;base64,#{receipt}" }
            }
          ]
        } ]
      }
      response = self.class.post(
        "/chat/completions",
        body: body.to_json
      )

      puts "Prompt: #{prompt}"
      puts "Response: #{response.to_json}"

      Response::Receipt.new(response)
    end

    def auto_reply(system_prompt, user_input, model: "gpt-4.1-nano")
      body = {
        model: model,
        messages: [
          { role: "system", content: system_prompt },
          { role: "user", content: user_input }
        ]
      }

      response = self.class.post(
        "/chat/completions",
        body: body.to_json
      )

      Response::AutoReply.new(response)
    end
  end
end
