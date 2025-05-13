# Not in use by the application yet, but implemented.
module GoogleDrive
  def self.gateway
    return BogusGateway.new unless enabled?

    @gateway ||= Gateway.new(api_json)
  end

  def self.enabled?
    !Rails.env.test?
  end

  private

  def self.api_json
    Rails.application.credentials.dig(:google_drive, :auth_json)
  end
end
