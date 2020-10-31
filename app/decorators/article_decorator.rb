class ArticleDecorator < ApplicationDecorator
  delegate_all

  def image_attached?(height: 300, width: 500)
    if object.image.attached?
      h.content_tag(:span, class: "prev-content") do
        h.image_tag(object.display_image, height: height, width: width, alt: "preview", class: "shadow-sm")
      end
    end
  end
end
