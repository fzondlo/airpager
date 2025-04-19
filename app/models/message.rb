class Message < ApplicationRecord
  validates :conversation_id, presence: true
end
