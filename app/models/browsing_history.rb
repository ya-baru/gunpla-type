class BrowsingHistory < ApplicationRecord
  belongs_to :user
  belongs_to :gunpla

  validates :user_id, presence: true
  validates :gunpla_id, presence: true
end
