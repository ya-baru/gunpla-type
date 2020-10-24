class Users::RelationshipsController < ApplicationController
  include ApplicationHelper
  prepend_before_action :authenticate_user!

  def create
    @user = User.find(params[:followed_id])
    unless current_user.following?(@user)
      current_user.follow(@user)
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
      respond_to do |format|
        format.html { redirect_to requeest.referrer || mypage_url(current_user) }
        format.js
      end
    end
  end
end
