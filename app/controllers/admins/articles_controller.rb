class Admins::ArticlesController < ApplicationController
  def index
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    return render :new unless @article.save

    redirect_to article_url(@article)
  end

  def edit
  end

  def update

  end

  def destroy

  end

  private

  def article_params
    params.require(:article).permit(:title, :content, :address, :latitude, :longitude)
  end
end
