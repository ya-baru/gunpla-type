class Users::RankingsController < ApplicationController
  def index
    @reviewer_rank = User.order(reviews_count: "desc").limit(3)

    @review_rank = Review.order(likes_count: "desc").limit(3)

    @gunpla_rank = Gunpla.order(favorites_count: "desc").limit(3)

    @follow_rank = User.order(relationships_count: "desc").limit(3)
  end
end
