module OpenAi
  class BogusGateway
    def chat(prompt, model: "gpt-4.1-nano-bogus")
      Response::Chat.new(RawResponse.new(fake_chat_response(prompt)))
    end

    private

    def fake_chat_response(prompt)
      if prompt.include?("Pretend that you are an Airbnb host and a customer is messaging you through the platform.")
        return chat_response("TRUE")
      end

      chat_response("You said: #{prompt}")
    end

    def chat_response(content)
      {
        "id" => "chatcmpl-#{rand(1000..9999)}",
        "object" => "chat.completion",
        "created" => Time.now.to_i,
        "model" => "gpt-4-bogus",
        "choices" => [
          {
            "index" => 0,
            "message" => {
              "role" => "assistant",
              "content" => content
            },
            "finish_reason" => "stop"
          }
        ],
        "usage" => {
          "prompt_tokens" => 5,
          "completion_tokens" => 7,
          "total_tokens" => 12
        }
      }
    end

    # Mimics HTTParty response
    class RawResponse
      attr_reader :parsed_response, :code

      def initialize(body, code = 200)
        @parsed_response = body
        @code = code
      end

      def success?
        code == 200
      end
    end
  end
end
