module OpenAi
  def self.gateway
    return BogusGateway.new unless enabled?

    @gateway ||= Gateway.new(api_token)
  end

  def self.enabled?
    !Rails.env.test? && api_token.present?
  end

  private

  def self.api_token
    Rails.application.credentials.dig(:open_ai, :api_token)
  end
end
