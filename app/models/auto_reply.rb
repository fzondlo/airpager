class AutoReply < ApplicationRecord
  has_many :auto_reply_properties, dependent: :destroy
  has_many :properties, through: :auto_reply_properties

  validates :trigger, presence: true
  validates :reply, presence: true

  validates :live_enabled, inclusion: { in: [true, false] }

  scope :live_enabled, -> { where(live_enabled: true) }
end
