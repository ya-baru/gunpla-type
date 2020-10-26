class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :review

  has_many :notifications, dependent: :destroy

  validates :content, presence: true, length: { maximum: 255 }
  validates :user_id, presence: true
  validates :review_id, presence: true
end
