class Users::GunplasController < ApplicationController
  before_action :authenticate_user!, only: %i(new create edit update)
  before_action :set_up, only: %i(show edit update)

  def index
    @gunplas = Gunpla.all
  end

  def show
    @gunpla = Gunpla.find(params[:id])
  end

  def new
    @gunpla = Gunpla.new
  end

  def create
    @gunpla = Gunpla.new(ganpla_params)
    return render :new unless @gunpla.save

    redirect_to mypage_path(current_user), notice: "ガンプラ登録に成功しました"
  end

  def edit
    @gunpla = Gunpla.find(params[:id])
  end

  def update
    return render :edit unless @gunpla.update(ganpla_params)

    redirect_to @gunpla, notice: "ガンプラを更新しました"
  end

  private

  def ganpla_params
    params.require(:gunpla).permit(:name, :sales_id)
  end

  def set_up
    @gunpla = Gunpla.find(params[:id])
  end
end
