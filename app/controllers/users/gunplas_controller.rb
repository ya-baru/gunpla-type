class Users::GunplasController < ApplicationController
  include CategorySearch
  include GunplaHistory

  before_action :authenticate_user!, only: %i(new create edit update)
  before_action :set_gunpla, only: %i(show edit update)
  before_action :set_parent_categories, only: %i(new create edit update index search_index select_category_index)
  before_action :set_category_data, only: %i(edit update)
  before_action :set_category, only: %i(index search_index)

  def index
    @search = Gunpla.ransack
    @gunplas = @search.result.page(params[:page]).per(9).decorate

    set_gunplas_page_data(@search.result.count, "ガンプラリスト", :gunpla_list)
  end

  def search_index
    @search = Gunpla.ransack(search_params)
    @gunplas = @search.result.page(params[:page]).per(9).decorate

    set_gunplas_page_data(@search.result.count, "検索結果", :gunpla_search)
    render :index
  end

  def select_category_index
    @category = Category.find_by(id: params[:id]).decorate
    category_listup(@category)

    @search = Gunpla.ransack
    @gunplas = Kaminari.paginate_array(@gunpla_list).page(params[:page]).per(9)

    set_gunplas_page_data(@gunplas.count, "カテゴリー検索", :category_search)
    render :index
  end

  def show
    @gunpla = Gunpla.find(params[:id]).decorate
    gunpla_history_save(@gunpla) if user_signed_in?
  end

  def new
    @gunpla = Gunpla.new.decorate
  end

  def create
    @gunpla = Gunpla.new(ganpla_params).decorate
    return render :new unless @gunpla.save

    redirect_to gunpla_url(@gunpla), notice: "ガンプラの登録に成功しました"
  end

  def edit; end

  def update
    return render :edit unless @gunpla.update(ganpla_params)

    redirect_to gunpla_url(@gunpla), notice: "ガンプラを更新しました"
  end

  def autocomplete
    names = Gunpla.by_name_like(autocomplete_params[:name]).pluck(:name).reject(&:blank?)
    render json: names
  end

  def get_category_children
    @category_children = Category.find(params[:parent_id]).children
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find(params[:child_id]).children
  end

  private

  def ganpla_params
    params.require(:gunpla).permit(:name, :sales_id, :category_id)
  end

  def search_params
    params.require(:q).permit(:name_cont)
  end

  def autocomplete_params
    params.permit(:name)
  end

  def set_gunpla
    @gunpla = Gunpla.find(params[:id]).decorate
  end

  def set_parent_categories
    @parent_categories = Category.where(ancestry: nil)
  end

  def set_category_data
    @category_children = @gunpla.category.parent.parent.children
    @category_grandchildren = @gunpla.category.parent.children

    @category_grandchild = @gunpla.category
    @category_child = @category_grandchild.parent
    @category_parent = @category_child.parent
  end

  def set_category
    @category = Category.new.decorate
  end

  def set_gunplas_page_data(gunplas_count, sub_title, breadcumb)
    @gunplas_count = gunplas_count
    @sub_title = sub_title
    @breadcumb = breadcumb
  end
end
