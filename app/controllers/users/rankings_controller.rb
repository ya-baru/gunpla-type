class Users::RankingsController < ApplicationController
  def index
    @reviewer_rank = User.order(reviews_count: "desc").limit(RANK_LIST_COUNT)

    @follow_rank = User.order(relationships_count: "desc").limit(RANK_LIST_COUNT)

    @gunpla_rank = Gunpla.order(favorites_count: "desc").limit(RANK_LIST_COUNT)

    @review_rank = Review.order(likes_count: "desc").limit(RANK_LIST_COUNT)
  end
end
