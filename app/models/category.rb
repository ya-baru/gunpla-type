class Category < ApplicationRecord
  has_ancestry
  has_many :gunplas, dependent: :destroy

  validates :name, presence: true
end
