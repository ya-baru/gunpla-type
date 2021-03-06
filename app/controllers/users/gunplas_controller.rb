class Users::GunplasController < ApplicationController
  include CategorySearch
  include GunplaHistory
  include GunplaSearch

  prepend_before_action :authenticate_user!, only: %i(new create edit update)
  before_action :set_gunpla, only: %i(show edit update)
  before_action :set_parent_categories, only: %i(new create edit update index search_index select_category_index)
  before_action :set_category_data, only: %i(edit update)
  before_action :set_category, only: %i(index search_index)

  def index
    gunpla_search(nil)

    set_gunplas_page_data(gunplas_count: @search.result.count, sub_title: "ガンプラリスト", breadcumb: :gunpla_list)
  end

  def search_index
    gunpla_search(search_params)

    set_gunplas_page_data(gunplas_count: @search.result.count, sub_title: "検索結果", breadcumb: :gunpla_search)
    render :index
  end

  def select_category_index
    @category = Category.find_by(id: params[:id]).decorate
    category_listup(@category)
    gunpla_search(nil)

    set_gunplas_page_data(gunplas_count: @gunpla_list.count, sub_title: "カテゴリー検索", breadcumb: :category_search)
    render :index
  end

  def show
    @gunpla = Gunpla.find(params[:id]).decorate
    @reviews = @gunpla.reviews.
      page(params[:page]).
      per(LIST_PAGINATE_COUNT).
      decorate.
      includes([images_attachments: :blob]).
      order(id: :desc)
    gunpla_history_save(@gunpla) if user_signed_in?
  end

  def new
    @gunpla = Gunpla.new.decorate
  end

  def create
    @gunpla = Gunpla.new(ganpla_params).decorate
    return render :new unless @gunpla.save

    redirect_to gunpla_url(@gunpla), notice: "ガンプラを登録しました"
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
    params.require(:gunpla).permit(:name, :sales, :category_id)
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

  def set_gunplas_page_data(gunplas_count: nil, sub_title: nil, breadcumb: nil)
    @gunplas_count = gunplas_count
    @sub_title = sub_title
    @breadcumb = breadcumb
  end
end
