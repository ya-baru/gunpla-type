class CategoryDecorator < ApplicationDecorator
  delegate_all

  def result
    if object.present?
      if root?
        h.content_tag(:div, name, class: "search_result")
      elsif childless?
        h.content_tag(:div, "#{root.name} / #{parent.name} / #{name}", class: "search_result")
      else
        h.content_tag(:div, "#{parent.name} / #{name}", class: "search_result")
      end
    end
  end

  def none_result(gunplas)
    if gunplas.blank? && object.id?
      if root?
        h.content_tag(:div, "『#{name}』に分類されるガンプラはありませんでした。", class: "search_result")
      elsif childless?
        h.content_tag(:div, "『#{root.name} / #{parent.name} / #{name}』に分類されるガンプラはありませんでした。", class: "search_result")
      else
        h.content_tag(:div, "『#{parent.name} / #{name}』に分類されるガンプラはありませんでした。", class: "search_result")
      end
    end
  end
end
