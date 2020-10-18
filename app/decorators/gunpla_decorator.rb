class GunplaDecorator < ApplicationDecorator
  decorates :gunpla
  decorates_association :category
  delegate_all

  decorates_association :reviews

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
