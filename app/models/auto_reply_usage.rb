class AutoReplyUsage < ApplicationRecord
  belongs_to :auto_reply

  validates :conversation_id, presence: true
end
