class Gunpla < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :sales

  validates :name, presence: true, length: { maximum: 50 }
  validates :sales_id, presence: true
end
