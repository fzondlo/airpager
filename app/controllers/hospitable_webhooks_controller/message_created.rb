class HospitableWebhooksController
  class MessageCreated
    attr_reader :payload

    def initialize(payload)
      @payload = payload
    end

    def body
      payload["data"]["body"]
    end

    def created_at
      payload["data"]["created_at"]
    end

    def platform
      payload["data"]["platform"]
    end

    def conversation_id
      payload["data"]["conversation_id"]
    end

    def reservation_id
      payload["data"]["reservation_id"]
    end

    def sender_role
      "#{payload["data"]["sender_role"]}"
    end

    def sender_type
      "#{payload["data"]["sender_type"]}"
    end

    def sender_full_name
      "#{payload["data"]["sender"]["full_name"]}"
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
end
