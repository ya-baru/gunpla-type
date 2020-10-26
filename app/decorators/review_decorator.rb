class ReviewDecorator < ApplicationDecorator
  delegate_all

  decorates_association :user
  decorates_association :gunpla
  decorates_association :comment

  def gunpla_name
    object.gunpla.name
  end

  def user_name
    object.user.username
  end

  def user_profile
    object.user.profile
  end
end
