module OpenAi
  def self.gateway
    @gateway ||= Gateway.new(api_token)
  end

  def self.api_token
    "something"
  end
end
