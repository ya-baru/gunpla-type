class BrowsingHistory < ApplicationRecord
  belongs_to :user
  belongs_to :gunpla

  validates :user_id, uniqueness: { scope: [:gunpla_id] }
end
