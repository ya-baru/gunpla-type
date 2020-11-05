class ReviewDecorator < ApplicationDecorator
  delegate_all
  decorates_association :user
  decorates_association :gunpla
  decorates_association :comment

  def gunpla_name
    gunpla.name
  end

  def user_name
    user.username
  end

  def user_profile
    user.profile
  end
end
