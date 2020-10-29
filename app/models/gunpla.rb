class Gunpla < ApplicationRecord
  include StringNormalizable

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :sales
  belongs_to :category

  has_many :browsing_histories, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user
  has_many :notifications, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }
  validates :sales_id, presence: true
  validates :category_id, presence: true

  scope :by_name_like, -> (name) {
    where("name LIKE :value", { value: "%#{sanitize_sql_like(name)}%" }).limit(AUTOCOMPETE_COUNT)
  }
end
