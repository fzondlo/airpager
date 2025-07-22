class AutoReplyUsage < ApplicationRecord
  belongs_to :auto_reply

  validates :conversation_id, presence: true
  validates :usage_type, presence: true
end
