class Like < ApplicationRecord
  belongs_to :user
  belongs_to :review

  validates :user_id, presence: true, uniqueness: { scope: :review_id }
  validates :review_id, presence: true
end
