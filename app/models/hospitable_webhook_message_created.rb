class HospitableWebhookMessageCreated
  attr_reader :payload

  def initialize(payload)
    @payload = payload
  end

  def platform
    payload["data"]["platform"]
  end

  def conversation_id
    payload["data"]["conversation_id"]
  end

  def contact_details
    "#{payload["data"]["sender"]["full_name"]} <#{payload["data"]["user"]["email"]}>"
  end

  def from_team?
    payload["data"]["sender_role"].in?(sender_roles_for_team)
  end

  def from_guest?
    !from_team?
  end

  private

  def sender_roles_for_team
    ["host", "co-host", "teammate"]
  end
end
