class UserDecorator < ApplicationDecorator
  delegate_all
  decorates_association :review
  decorates_association :comment
  decorates_association :like

  def avatar_attached?(height: 140, width: 140)
    if object.avatar.attached?
      h.content_tag(:span, class: "prev-content") do
        h.image_tag(object.display_avatar, height: height, width: width, alt: "preview", class: "prev-image shadow")
      end
    else
      h.image_tag("https://placehold.jp/#{height}x#{width}.png?text=Non-Image", class: "photo-icon shadow")
    end
  end

  def review_registered?(gunpla)
    if object.reviews.find_by(gunpla_id: gunpla.id)
      h.link_to "『#{gunpla.name}』 のレビューを編集する", h.edit_review_path(Review.find_by(user_id: h.current_user.id, gunpla_id: gunpla.id)), class: "btn btn-primary btn-block px-0"
    else
      h.link_to "『#{gunpla.name}』 をレビューする", h.new_gunpla_review_path(gunpla), class: "btn btn-primary btn-block"
    end
  end

  def unchecked_notifications
    object.passive_notifications.where(checked: false)
  end
end
