module Users::ReviewHelper
  def images_attached?(review, height)
    if review.present? && review.images.attached?
      image_tag review.display_images.first, class: "card-img-top", height: height
    else
      image_tag("https://placehold.jp/250x250.png?text=Non-Image", class: "card-img-top", height: height)
    end
  end
end
