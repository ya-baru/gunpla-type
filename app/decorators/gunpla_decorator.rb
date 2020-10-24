class GunplaDecorator < ApplicationDecorator
  decorates :gunpla
  decorates_association :category
  decorates_association :review

  delegate_all

  def category_name
    object.category.name
  end

  def root_category_name
    object.category.root.name
  end

  def parent_category_name
    object.category.parent.name
  end

  def images_attached?(height)
    if object.reviews.present?
      review = object.reviews.last
      if review.present?
        h.image_tag review.display_images.first, class: "card-img-top", height: height
      end
    else
      h.image_tag("https://placehold.jp/250x250.png?text=Non-Image", class: "card-img-top", height: height)
    end
  end
end
