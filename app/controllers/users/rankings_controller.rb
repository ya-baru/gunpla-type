class Users::RankingsController < ApplicationController
  def index
    @review_rank = User.
      joins(:reviews).
      group(:username).
      order("count(reviews.user_id) desc").
      limit(3).count
    @reviewer_link = User.
      joins(:reviews).
      group(:username, :id).
      order("count(reviews.user_id) desc").
      limit(3).count

    @like_rank = Review.
      joins(:likes).
      group(:title).
      order('count(likes.review_id) desc').
      limit(3).count
    @review_link = Review.
      joins(:likes).
      group(:title, :id).
      order('count(likes.review_id) desc').
      limit(3).count

    @favorite_rank = Gunpla.
      joins(:favorites).
      group(:name).
      order("count(favorites.gunpla_id) desc").
      limit(3).count
    @gunpla_link = Gunpla.
      joins(:favorites).
      group(:name, :id).
      order("count(favorites.gunpla_id) desc").
      limit(3).count

    @follow_rank = User.
      joins(:passive_relationships).
      group(:username).
      order("count(relationships.followed_id) desc").
      limit(3).count
    @follow_link = User.
      joins(:passive_relationships).
      group(:username, :id).
      order("count(relationships.followed_id) desc").
      limit(3).count
  end
end
