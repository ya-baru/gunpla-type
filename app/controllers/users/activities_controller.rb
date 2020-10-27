class Users::ActivitiesController < ApplicationController
  prepend_before_action :authenticate_user!

  def index
    @activities = current_user.active_notifications.where.not(action: "review").
      or(current_user.active_notifications.where(visited_id: current_user.id, action: "review")).
      page(params[:page]).
      per(ACTIVITY_PAGINATE_COUNT).
      order(created_at: :desc).
      includes(
        [:visitor, :comment, :gunpla],
        [review: [:user, :gunpla]],
        [visited: [avatar_attachment: :blob]]
      )
  end
end
