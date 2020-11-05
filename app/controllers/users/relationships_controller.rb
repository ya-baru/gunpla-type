class Users::RelationshipsController < ApplicationController
  include ApplicationHelper
  prepend_before_action :authenticate_user!

  def create
    @user = User.find(params[:followed_id])
    return redirect_to mypage_url(@user) if current_user?(@user)

    unless current_user.following?(@user)
      current_user.follow(@user)
      @user.reload
      @user.create_notification_follow(current_user)
      respond_to do |format|
        format.html { redirect_to request.referrer || mypage_url(current_user) }
        format.js
      end
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    if current_user.following?(@user)
      current_user.unfollow(@user)
      @user.reload
      respond_to do |format|
        format.html { redirect_to requeest.referrer || mypage_url(current_user) }
        format.js
      end
    end
  end
end
