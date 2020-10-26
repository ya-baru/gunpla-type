class Users::NotificationsController < ApplicationController
  prepend_before_action :authenticate_user!

  def index
    @notifications = current_user.passive_notifications.
      where(checked: false).
      page(params[:page]).
      per(NOTIFICATION_PAGINATE_COUNT).
      order(created_at: :desc).
      includes(
        [:visited, :comment, :gunpla],
        [review: [:user, :gunpla]],
        [visitor: [avatar_attachment: :blob]]
      )
    # @notifications.where(checked: false).each do |notification|
    #   notification.update_attributes(checked: true)
    # end
  end

  def update
    notification = Notification.find(params[:id])
    notification.update_attributes(checked: true)
    redirect_to request.referer || mypage_url(current_user)
  end
end
