module Follow
  extend ActiveSupport::Concern
  included do
    def follow(other_user)
      following << other_user
    end

    def unfollow(other_user)
      active_relationships.find_by(followed_id: other_user.id).destroy
    end

    def following?(other_user)
      following.include?(other_user)
    end
  end
end
