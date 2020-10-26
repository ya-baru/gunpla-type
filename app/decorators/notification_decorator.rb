class NotificationDecorator < ApplicationDecorator
  delegate_all

  def review_gunpla_name
    object.review.gunpla.name
  end

  def gunpla_name
    object.gunpla.name
  end
end
