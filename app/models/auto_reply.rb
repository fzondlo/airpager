class AutoReply < ApplicationRecord
  validates :trigger, presence: true
  validates :reply, presence: true
end
