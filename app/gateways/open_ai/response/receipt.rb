module OpenAi
  class Response
    class Receipt < Response
      def date
        response[:date]
      end

      def usd
        number_to_currency(response[:cost_in_usd])
      end

      def cop
        number_to_currency(response[:cost_in_cop])
      end

      def description
        response[:description]
      end

      private

      def response
        JSON.parse(body["choices"][0]["message"]["content"], symbolize_names: true)
      end
    end
  end
end

