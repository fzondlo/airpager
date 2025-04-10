class Incident < ApplicationRecord
  validates :kind, presence: true

  def alert!
    update(status: "alerted", alerted_at: Time.current)
    #PagerDutyClient.alert(self)
  end

  def resolve!
    update(status: "resolved", resolved_at: Time.current)
  end
end
