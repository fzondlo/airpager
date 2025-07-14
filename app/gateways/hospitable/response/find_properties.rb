module Hospitable
  class Response
    class FindProperties < Response
      def properties
        body["data"].map do |property_data|
          prop = property_data.with_indifferent_access
          {
            id: prop[:id],
            name: prop[:name]
          }
        end
      end
    end
  end
end
