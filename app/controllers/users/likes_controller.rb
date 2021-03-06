class Users::LikesController < ApplicationController
  include ApplicationHelper
  prepend_before_action :authenticate_user!

  def create
    @review = Review.find(params[:review_id])
    return redirect_to review_url(@review) if current_user?(@review.user)

    unless current_user.like?(@review)
      current_user.uplike(@review)
      @review.reload
      @review.create_notification_like(current_user)
      respond_to do |format|
        format.html { redirect_to request.referrer || review_url(@review) }
        format.js
      end
    end
  end

  def destroy
    @review = Like.find(params[:id]).review
    if current_user.like?(@review)
      current_user.unlike(@review)
      @review.reload
      respond_to do |format|
        format.html { redirect_to request.referrer || review_url(@review) }
        format.js
      end
    end
  end
end
