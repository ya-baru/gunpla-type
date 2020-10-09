class Category < ApplicationRecord
  has_ancestry
  has_many :gunplas

  validates :name, presence: true
end
