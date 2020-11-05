class GunplaDecorator < ApplicationDecorator
  delegate_all
  decorates_association :category
  decorates_association :review

  def category_name
    category.name
  end

  def root_category_name
    category.root.name
  end

  def parent_category_name
    category.parent.name
  end

  def reviews_count
    reviews.count
  end

  def images_attached?(height: nil, width: nil)
    if object.reviews.present?
      review = object.reviews.order(id: "desc").first
      h.image_tag review.display_images.first, class: "card-img-top", height: height, width: width
    else
      h.image_tag("https://placehold.jp/180x180.png?text=Non-Image", class: "card-img-top", height: height)
    end
  end
end
