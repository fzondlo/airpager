module Hospitable
  class Response
    class FindInquiry < Response
      def property
        body["data"]["properties"] # Note: "properties" is plural but it'll always return just one record, no array.
      end
    end
  end
end
