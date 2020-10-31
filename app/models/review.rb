class Review < ApplicationRecord
  include ReviewImages
  include NotificationCreate

  has_many_attached :images, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  belongs_to :user
  belongs_to :gunpla

  counter_culture :user

  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 1000 }
  validates :user_id, presence: true, uniqueness: { scope: :gunpla_id }
  validates :gunpla_id, presence: true
  validates :rate, presence: true, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1,
  }
  validates :likes_count, presence: true
  validate :images_type, :images_size, :images_length
end
