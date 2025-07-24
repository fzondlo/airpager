module TwilioApi
  def self.gateway
    return BogusGateway.new unless enabled?

    @gateway ||= Gateway.new(account_sid, auth_token)
  end

  def self.enabled?
    !Rails.env.test? && has_credentials?
  end

  private

  def self.has_credentials?
    account_sid.present? && auth_token.present?
  end

  def self.account_sid
    Rails.application.credentials.dig(:twilio, :account_sid)
  end

  def self.auth_token
    Rails.application.credentials.dig(:twilio, :auth_token)
  end
end
