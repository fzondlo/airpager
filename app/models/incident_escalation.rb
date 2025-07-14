class IncidentEscalation < ApplicationRecord
  belongs_to :incident

  has_secure_token :token
  validates :token, presence: true, uniqueness: true

  scope :active, -> { where(triggered_at: nil).where("expires_at IS NULL OR expires_at > ?", Time.current) }
  scope :expired, -> { where("expires_at <= ?", Time.current) }
  scope :triggered, -> { where.not(triggered_at: nil) }

  def expired?
    (expires_at.present? && (Time.current > expires_at))
  end

  def triggered?
    triggered_at.present?
  end

  def triggered!
    update(triggered_at: Time.current)
  end
end
