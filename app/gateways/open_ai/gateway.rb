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

      track_open_ai_request(
        request_type: "chat",
        model: model,
        user_prompt: prompt,
        response: response
      )

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

      track_open_ai_request(
        request_type: "process_receipt",
        model: model,
        user_prompt: prompt,
        response: response
      )

      Response::Receipt.new(response)
    end

    def find_auto_reply(system_prompt, user_prompt, model: "gpt-4.1-nano")
      body = {
        model: model,
        messages: [
          { role: "system", content: system_prompt },
          { role: "user", content: user_prompt }
        ]
      }

      response = self.class.post(
        "/chat/completions",
        body: body.to_json
      )

      track_open_ai_request(
        request_type: "find_auto_reply",
        model: model,
        system_prompt: system_prompt,
        user_prompt: user_prompt,
        response: response
      )

      Response::FindAutoReply.new(response)
    end

    private

    def track_open_ai_request(request_type:, model:, system_prompt: nil, user_prompt:, response:)
      OpenAiRequest.create(
        request_id: response.headers['x-request-id'],
        request_type: request_type,
        model: model,
        system_prompt: system_prompt,
        user_prompt: user_prompt,
        response_headers: response.headers,
        response_payload: response.parsed_response,
        success: response.success?,
        answer: response.parsed_response.dig("choices", 0, "message", "content")
      )
    end
  end
end
