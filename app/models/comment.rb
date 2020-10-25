class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :review

  validates :content, presence: true, length: { maximum: 255 }
  validates :user_id, presence: true
  validates :review_id, presence: true
end
