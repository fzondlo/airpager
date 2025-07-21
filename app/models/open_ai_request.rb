class OpenAiRequest < ApplicationRecord
  validates :user_prompt, presence: true
  validates :response_payload, presence: true
end
