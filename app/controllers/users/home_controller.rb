class Users::HomeController < ApplicationController
  def index
    @articles = Article.limit(10).order(created_at: "desc").decorate
    @gunplas = Gunpla.includes([:category, :reviews]).order(favorites_count: "desc").limit(RANK_LIST_COUNT).decorate
    @reviews = Review.limit(5).order(created_at: "desc").decorate
  end
end
