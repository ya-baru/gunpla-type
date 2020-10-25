class CommentDecorator < ApplicationDecorator
  delegate_all
  decorates_association :user
  decorates_association :review

  def user_name
    object.user.username
  end
end
