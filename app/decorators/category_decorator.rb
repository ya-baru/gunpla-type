class CategoryDecorator < ApplicationDecorator
  delegate_all
  decorates_association :gunplas

  def result
    return unless object.present?

    if root?
      h.content_tag(:div, name, class: "search_result")
    elsif childless?
      h.content_tag(:div, "#{root.name} / #{parent.name} / #{name}", class: "search_result")
    else
      h.content_tag(:div, "#{parent.name} / #{name}", class: "search_result")
    end
  end

  def none_result(gunplas)
    return unless gunplas.count.zero?

    if root?
      h.content_tag(:div, "『#{name}』に分類されるガンプラはありませんでした。", class: "search_result")
    elsif childless?
      h.content_tag(:div, "『#{root.name} / #{parent.name} / #{name}』に分類されるガンプラはありませんでした。", class: "search_result")
    else
      h.content_tag(:div, "『#{parent.name} / #{name}』に分類されるガンプラはありませんでした。", class: "search_result")
    end
  end

  def grade_and_scale
    "#{parent.name} #{name}"
  end
end
