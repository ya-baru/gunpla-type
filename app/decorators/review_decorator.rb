class ReviewDecorator < ApplicationDecorator
  delegate_all

  decorates_association :user
  decorates_association :gunpla

  def gunpla_name
    object.gunpla.name
  end
end
