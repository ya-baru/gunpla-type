class Article < ApplicationRecord
  include ArticleImage

  geocoded_by :address
  after_validation :geocode

  has_rich_text :content
  has_one_attached :image

  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 1000 }
  validate :image_type, :image_size
end
