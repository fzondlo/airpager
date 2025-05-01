class OpenAiRequest < ApplicationRecord
  validates :prompt, presence: true
  validates :answer, presence: true
  validates :response_payload, presence: true
end
