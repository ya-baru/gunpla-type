class BrowsingHistory < ApplicationRecord
  belongs_to :user
  belongs_to :gunpla

  validates :user_id, presence: true, uniqueness: { scope: :gunpla_id }
  validates :gunpla_id, presence: true
end
