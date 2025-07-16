module OpenAi
  class Response
    class FindAutoReply < Response
      def auto_reply_id
        return unless answer.present?
        return if answer == "AUTO_REPLY_ID_NOT_FOUND"
        return unless valid_id_format?(answer)

        answer
      end

      def answer
        body["choices"][0]["message"]["content"]
      end

      def error_message
        body["error"]["message"]
      end

      def error_type
        body["error"]["type"]
      end

      private

      def valid_id_format?(answer)
        Integer(answer) # Try to cast as Integer
        true
      rescue
        false
      end
    end
  end
end
