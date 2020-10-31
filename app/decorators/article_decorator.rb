class ArticleDecorator < ApplicationDecorator
  delegate_all

  def image_attached?(height: 400, width: 400)
    if object.image.attached?
      h.content_tag(:span, class: "prev-content") do
        h.image_tag(object.display_image, height: height, width: width, alt: "preview", class: "shadow-sm")
      end
    else
      h.image_tag(h.asset_path("amuro.jpg"), alt: "Amuro Ray", class: "shadow-sm", height: 150, width: 150)
    end
  end
end
