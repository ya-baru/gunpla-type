class Users::GunplasController < ApplicationController
  before_action :authenticate_user!, only: %i(new create edit update)

  def index
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
  end

  def update
  end

  private

  def ganpla_params
    params.require(:gunpla).permit(:name, :sales_id)
  end
end
