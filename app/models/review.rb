class Review < ApplicationRecord
  include Images

  has_many_attached :images, dependent: :destroy

  belongs_to :user
  belongs_to :gunpla

  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 1000 }
  validates :user_id, presence: true, uniqueness: { scope: :gunpla_id }
  validates :gunpla_id, presence: true
  validates :rate, presence: true, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1,
  }
  validate :images_type, :images_size, :images_length
end
