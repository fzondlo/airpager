module Whatsapp
  def self.gateway
    return BogusGateway.new unless enabled?

    @gateway ||= Gateway.new
  end

  def self.enabled?
    !Rails.env.test?
  end

  private

end
