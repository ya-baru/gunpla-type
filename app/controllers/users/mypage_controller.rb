class Users::MypageController < ApplicationController
  prepend_before_action :authenticate_user!, only: [:show]
  before_action :setup_user

  def show
    @reviews = @user.reviews.
      page(params[:page]).
      per(REVIEWS_PAGINATE_COUNT).
      decorate.
      includes([gunpla: :category]).
      # includes([gunpla: :category], [images_attachments: :blob]).
      order(id: :desc)
  end

  def iine_reviews
    @iine_reviews = @user.iine_reviews
  end

  def favorite_gunplas
    @favorite_gunplas = @user.favorite_gunplas
  end

  def following
    @follwing = @user.active_relationships
  end

  def followers
    @followers = @user.passive_relationships
  end

  private

  def setup_user
    @user = User.find_by(id: params[:id]).decorate || current_user.decorate
  end
end
