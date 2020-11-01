module ArticleImage
  extend ActiveSupport::Concern
  included do
    def display_image(height: 300, width: 300)
      image.variant(resize_to_fill: [height, width]).processed
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
end
