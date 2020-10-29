class Users::FavoritesController < ApplicationController
  include ApplicationHelper
  prepend_before_action :authenticate_user!

  def create
    @gunpla = Gunpla.find(params[:gunpla_id])
    unless current_user.favorite?(@gunpla)
      current_user.favorite(@gunpla)
      respond_to do |format|
        format.html { redirect_to request.referrer || gunpla_url(@gunpla) }
        format.js
      end
    end
  end

  def destroy
    @gunpla = Favorite.find(params[:id]).gunpla
    if current_user.favorite?(@gunpla)
      current_user.unfavorite(@gunpla)
      respond_to do |format|
        format.html { redirect_to request.referrer || gunpla_url(@gunpla) }
        format.js
      end
    end
  end
end
