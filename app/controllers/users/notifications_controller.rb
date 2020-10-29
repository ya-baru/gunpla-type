class Users::NotificationsController < ApplicationController
  prepend_before_action :authenticate_user!

  def index
    @notifications = current_user.passive_notifications.
      where(checked: false).
      page(params[:page]).
      per(NOTIFICATION_PAGINATE_COUNT).
      order(created_at: :desc).
      includes(
        [:visited, :gunpla],
        [review: [:gunpla]],
        [visitor: [avatar_attachment: :blob]]
      )
  end

  def update
    all_complete
    redirect_to request.referer || mypage_url(current_user)
  end

  private

  def notification_params
    params.require(:notification)
  end

  def all_complete
    if notification_params.present?
      notifications = Notification.where(id: notification_params[:ids].split.map(&:to_i))
      notifications.each do |notification|
        notification.update(checked: true)
      end
    end
  end
end
