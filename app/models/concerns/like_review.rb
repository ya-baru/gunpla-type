module LikeReview
  extend ActiveSupport::Concern
  included do
    def uplike(review)
      like_reviews << review
    end

    def unlike(review)
      likes.find_by(review_id: review.id).destroy
    end

    def like?(review)
      like_reviews.include?(review)
    end
  end
end
