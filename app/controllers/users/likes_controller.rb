class Users::LikesController < ApplicationController
  prepend_before_action :authenticate_user!

  def create
    @review = Review.find(params[:review_id])
    unless current_user.iine?(@review)
      current_user.iine(@review)
      respond_to do |format|
        format.html { redirect_to request.referrer || review_url(@review) }
        format.js
      end
    end
  end

  def destroy
    @review = Like.find(params[:id]).review
    if current_user.iine?(@review)
      current_user.uniine(@review)
      respond_to do |format|
        format.html { redirect_to request.referrer || review_url(@review) }
        format.js
      end
    end
  end
end
