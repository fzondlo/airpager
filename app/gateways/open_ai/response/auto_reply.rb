module OpenAi
  class Response
    class AutoReply < Response
      def answer
        body["choices"][0]["message"]["content"]
      end

      def error_message
        body["error"]["message"]
      end

      def error_type
        body["error"]["type"]
      end
    end
  end
end
