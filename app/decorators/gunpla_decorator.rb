class GunplaDecorator < ApplicationDecorator
  decorates :gunpla
  decorates_association :category
  decorates_association :review

  delegate_all

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
