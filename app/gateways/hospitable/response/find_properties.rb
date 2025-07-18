module Hospitable
  class Response
    class FindProperties < Response
      def properties
        body["data"]
      end
    end
  end
end
