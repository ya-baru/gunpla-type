class Users::MypageController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def show
    @user = User.find_by(id: params[:id])
    return redirect_to users_mypage_path(current_user) if @user.blank?
  end
end
