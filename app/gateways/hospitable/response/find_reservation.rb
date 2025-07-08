module Hospitable
  class Response
    class FindReservation < Response
      def properties
        body["data"]["properties"]
      end

      def property
        properties.first
      end
    end
  end
end
