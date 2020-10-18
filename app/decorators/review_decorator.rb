class ReviewDecorator < ApplicationDecorator
  delegate_all

  decorates_association :user
  decorates_association :gunpla
end
