class CategoryDecorator < ApplicationDecorator
  delegate_all

  def result
    if object.present?
      if root?
        name
      elsif childless?
        "#{root.name} / #{parent.name} / #{name}"
      else
        "#{parent.name} / #{name}"
      end
    end
  end

  def none_result(gunplas)
    if gunplas.blank? && object.id?
      if root?
        "『#{name}』に分類されるガンプラはありませんでした。"
      elsif childless?
        "『#{root.name} / #{parent.name} / #{name}』に分類されるガンプラはありませんでした。"
      else
        "『#{parent.name} / #{name}』に分類されるガンプラはありませんでした。"
      end
    end
  end
end
