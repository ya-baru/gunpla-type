class ReviewDecorator < ApplicationDecorator
  delegate_all

  decorates_association :user
  decorates_association :gunpla

  def gunpla_name
    object.gunpla.name
  end

  def user_name
    object.user.username
  end

  def user_profile
    object.user.profile
  end

  def use_avatar
    h.link_to h.mypage_path(object.user) do
      if object.user.avatar.attached?
        h.image_tag object.user.display_avatar(80), class: "shadow rounded-circle"
      else
        h.image_tag("https://placehold.jp/80x80.png?text=Non-Image", class: "shadow rounded-circle")
      end
    end
  end
end
