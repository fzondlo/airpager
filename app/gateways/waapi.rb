module Allquiet
  def self.gateway
    return BogusGateway.new unless enabled?

    @gateway ||= Gateway.new(webhook_token)
  end

  def self.enabled?
    !Rails.env.test? && webhook_token.present?
  end

  private

  def self.webhook_token
    Rails.application.credentials.dig(:waapi, :api_token)
  end
end
