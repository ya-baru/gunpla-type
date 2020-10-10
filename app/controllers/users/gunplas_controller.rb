class Users::GunplasController < ApplicationController
  before_action :authenticate_user!, only: %i(new create edit update get_category_children get_category_grandchildren)
  before_action :set_gunpla, only: %i(show edit update)
  before_action :set_category_parents, only: %i(new create edit update)
  before_action :set_category_data, only: %i(edit update)

  def index
    @search = Gunpla.ransack(params[:q])
    @gunplas = @search.result.page(params[:page]).per(9)
  end

  def search
    @search = Gunpla.search(search_params)
    @gunplas = @search.result.page(params[:page]).per(9)
    @gunplas_count = @search.result.count
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

    redirect_to @gunpla, notice: "ガンプラの登録に成功しました"
  end

  def edit; end

  def update
    return render :edit unless @gunpla.update(ganpla_params)

    redirect_to @gunpla, notice: "ガンプラを更新しました"
  end

  def get_category_children
    @category_children = Category.find("#{params[:parent_id]}").children
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end

  private

  def ganpla_params
    params.require(:gunpla).permit(:name, :sales_id, :category_id)
  end

  def search_params
    params.require(:q).permit(:name_cont)
  end

  def set_gunpla
    @gunpla = Gunpla.find(params[:id])
  end

  def set_category_parents
    @category_parents = Category.where(ancestry: nil)
  end

  def set_category_data
    @category_children = @gunpla.category.parent.parent.children
    @category_grandchildren = @gunpla.category.parent.children

    @category_grandchild = @gunpla.category
    @category_child = @category_grandchild.parent
    @category_parent = @category_child.parent
  end
end
