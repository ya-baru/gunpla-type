class Gunpla < ApplicationRecord
  include StringNormalizable

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :sales
  belongs_to :category

  validates :name, presence: true, length: { maximum: 50 }
  validates :sales_id, presence: true
  validates :category_id, presence: true
end
