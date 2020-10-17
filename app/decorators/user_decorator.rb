class UserDecorator < ApplicationDecorator
  delegate_all
  def use_avatar
    if object.avatar.present?
      h.content_tag(:div, class: "prev-content") do
        h.image_tag(object.avatar, alt: "preview", class: "prev-image shadow", size: "150x150")
      end
    else
      h.image_tag("https://placehold.jp/150x150.png?text=Non-Image", class: "photo-icon shadow")
    end
  end
end
