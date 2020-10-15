class GunplaDecorator < ApplicationDecorator
  decorates :gunpla
  delegate_all
  decorates_association :category
  decorates_association :gunplas

  def category_name
    category.name
  end

  def root_category_name
    category.root.name
  end

  def parent_category_name
    category.parent.name
  end
end
