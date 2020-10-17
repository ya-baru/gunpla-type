module AvatarResize
  extend ActiveSupport::Concern
  included do
    def display_avatar
      avatar.variant(resize_to_limit: [150, 150])
    end
  end
end
