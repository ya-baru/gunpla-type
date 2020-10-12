class Gunpla < ApplicationRecord
  include StringNormalizable

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :sales
  belongs_to :category

  has_many :browsing_histories, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  validates :sales_id, presence: true
  validates :category_id, presence: true

  scope :by_name_like, -> (name) {
    where("name LIKE :value", { value: "%#{sanitize_sql_like(name)}%" }).limit(SUGGEST_COUNT)
  }
end
