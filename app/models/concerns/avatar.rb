module Avatar
  extend ActiveSupport::Concern
  included do
    def display_avatar
      avatar.variant(resize_to_limit: [150, 150]).processed
    end

    private

    def avatar_type
      return unless avatar.attached?
      if !avatar.blob.content_type.in?(%("image/jpeg image/jpg image/png"))
        avatar
        errors.add(:avatar, "は『jpeg, jpg, png』形式でアップロードしてください")
      end
    end

    def avatar_size
      return unless avatar.attached?
      if avatar.blob.byte_size > 3.megabytes
        avatar
        errors.add(:avatar, "のファイルは3MB以内にしてください")
      end
    end
  end
end
