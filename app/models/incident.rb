class Incident < ApplicationRecord
  validates :kind, presence: true

  scope :pending, -> { where(resolved_at: nil) }
  scope :resolved, -> { where.not(resolved_at: nil) }

  after_initialize :set_defaults, if: :new_record?

  def alert!
    update(status: "alerted", alerted_at: Time.current)
  end

  def resolve!(by: '')
    update(status: "resolved", resolved_by: by, resolved_at: Time.current)
  end

  private

  def set_defaults
    self.status ||= "created"
  end
end
