class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :gunpla

  counter_culture :user
  counter_culture :gunpla

  validates :user_id, presence: true, uniqueness: { scope: :gunpla_id }
  validates :gunpla_id, presence: true
end
