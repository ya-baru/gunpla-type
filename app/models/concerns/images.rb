module Images
  extend ActiveSupport::Concern
  included do
    def display_images(height: 180, weight: 180)
      images.includes([:blob]).each { |image| image.variant(resize_to_limit: [height, weight]).processed }
    end

    private

    def images_type
      return errors.add(:images, 'ファイルを添付してください') unless images.attached?
      images.each do |image|
        if !image.blob.content_type.in?(%('image/jpeg image/jpg image/png'))
          image
          errors.add(:images, 'は『jpeg, jpg, png』形式でアップロードしてください')
        end
      end
    end

    def images_size
      images.each do |image|
        if image.blob.byte_size > 3.megabytes
          image
          errors.add(:images, "は1つのファイル3MB以内にしてください")
        end
      end
    end

    def images_length
      if images.length > 3
        images
        errors.add(:images, "は3枚以内にしてください")
      end
    end
  end
end
