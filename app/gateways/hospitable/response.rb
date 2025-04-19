module Hospitable
  class Response
    delegate :success?, to: :raw_response

    attr_reader :raw_response

    def initialize(raw_response)
      @raw_response = raw_response
    end

    def body
      @body ||= raw_response.parsed_response
    end
  end
end
