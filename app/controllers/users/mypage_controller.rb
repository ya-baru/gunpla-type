class Users::MypageController < ApplicationController
  prepend_before_action :authenticate_user!, only: [:show]

  def show
    @user = User.find_by(id: params[:id]) || current_user
  end
end
