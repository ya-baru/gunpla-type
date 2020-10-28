class Users::MypageController < ApplicationController
  prepend_before_action :authenticate_user!, only: [:show]

  def show
    @user = User.find_by(id: params[:id]).decorate || current_user.decorate
    @reviews = @user.reviews
  end

  def iine_review

  end

  def new_review

  end

  def favorite_gunpla

  end

  def follow

  end

  def follower

  end
end
