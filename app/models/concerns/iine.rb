module Iine
  extend ActiveSupport::Concern
  included do
    def iine(review)
      iine_reviews << review
    end

    def uniine(review)
      likes.find_by(review_id: review.id).destroy
    end

    def iine?(review)
      iine_reviews.include?(review)
    end
  end
end
