class Property < ApplicationRecord
  has_many :auto_reply_properties, dependent: :destroy
  has_many :auto_replies, through: :auto_reply_properties

  before_validation :generate_slug

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :clickup_custom_field_id, presence: true
  validates :hospitable_id, presence: true

  private

  def generate_slug
    return unless name.present?
    self.slug = name.to_s.parameterize
  end
end
