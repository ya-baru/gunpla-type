class Users::ArticlesController < ApplicationController
  def index
    @articles = Article.page(params[:page]).per(LIST_PAGINATE_COUNT).includes([image_attachment: :blob]).order(id: :desc).decorate
  end

  def show
    @article = Article.find(params[:id]).decorate
  end
end
