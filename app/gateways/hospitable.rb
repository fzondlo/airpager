# Not in use by the application yet, but implemented.
module Hospitable
  def self.gateway
    return BogusGateway.new unless enabled?

    @gateway ||= Gateway.new(api_token)
  end

  def self.enabled?
    !Rails.env.test?
  end

  private

  def self.api_token
    Rails.application.credentials.dig(:hospitable, :api_token)
  end
end
