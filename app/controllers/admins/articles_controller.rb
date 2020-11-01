class Admins::ArticlesController < ApplicationController
  prepend_before_action :authenticate_user!
  before_action :user_admin?
  before_action :setup_article, only: %i(show edit update destroy)

  def index
    @articles = Article.page(params[:page]).per(LIST_PAGINATE_COUNT).order(id: :desc)
  end

  def show; end

  def new
    @article = Article.new.decorate
  end

  def create
    @article = Article.new(article_params).decorate
    return render :new unless @article.save

    redirect_to admins_article_url(@article), notice: "『#{@article.title}』を投稿しました"
  end

  def edit; end

  def update
    return render :edit unless @article.update(article_params)

    redirect_to admins_article_url(@article), notice: "『#{@article.title}』を更新しました"
  end

  def destroy
    @article.destroy
    redirect_to admins_articles_url, notice: "『#{@article.title}』を削除しました"
  end

  private

  def article_params
    params.require(:article).permit(:title, :content, :building, :address, :latitude, :longitude, :image)
  end

  def setup_article
    @article = Article.find(params[:id]).decorate
  end

  def user_admin?
    redirect_to mypage_path(current_user) unless current_user.admin_flg?
  end
end
