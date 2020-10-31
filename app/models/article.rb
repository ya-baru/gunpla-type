class Article < ApplicationRecord
  geocoded_by :address
  after_validation :geocode

  has_rich_text :content
  has_one_attached :image

  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 1000 }
  validate :image_type, :image_size

  def display_image(height: 250, width: 250)
    image.variant(resize_to_limit: [height, width]).processed
  end

  private

  def image_type
    return unless image.attached?
    if !image.blob.content_type.in?(%("image/jpeg image/jpg image/png"))
      image
      errors.add(:image, "は『jpeg, jpg, png』形式でアップロードしてください")
    end
  end

  def image_size
    return unless image.attached?
    if image.blob.byte_size > 3.megabytes
      image
      errors.add(:image, "のファイルは3MB以内にしてください")
    end
  end
end
