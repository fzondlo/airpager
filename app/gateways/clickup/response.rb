module Clickup
  class Response
    attr_reader :parsed_response

    def initialize(parsed_response)
      @parsed_response = parsed_response
    end

    def body
      @body ||= parsed_response.with_indifferent_access
    end
  end
end
