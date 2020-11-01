class GunplaDecorator < ApplicationDecorator
  delegate_all
  decorates_association :category
  decorates_association :review

  def category_name
    object.category.name
  end

  def root_category_name
    object.category.root.name
  end

  def parent_category_name
    object.category.parent.name
  end

  def reviews_count
    object.reviews.count
  end

  def images_attached?(height: nil, width: nil)
    if object.reviews.present?
      review = object.reviews.last
      h.image_tag review.display_images.first, class: "card-img-top", height: height, width: width
    else
      h.image_tag("https://placehold.jp/180x180.png?text=Non-Image", class: "card-img-top", height: height)
    end
  end
end
