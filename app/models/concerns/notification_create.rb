module NotificationCreate
  extend ActiveSupport::Concern
  included do
    # フォロー
    def create_notification_follow(current_user)
      temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ?", current_user.id, id, "follow"])
      if temp.blank?
        notification = current_user.active_notifications.build(
          visited_id: id,
          action: "follow"
        )
        notification.save if notification.valid?
      end
    end

    # いいね！
    def create_notification_like(current_user)
      temp = Notification.where(
        ["visitor_id = ? and visited_id = ? and review_id = ? and action = ?", current_user.id, user_id, id, "like"]
      )
      if temp.blank?
        notification = current_user.active_notifications.build(
          review_id: id,
          visited_id: user_id,
          action: "like"
        )
        if notification.visitor_id == notification.visited_id
          notification.checked = true
        end
        notification.save if notification.valid?
      end
    end

    # お気に入りレビュー
    def create_notification_review(current_user, gunpla_id)
      temp_ids = Favorite.select(:user_id).where(gunpla_id: gunpla_id).where.not(user_id: current_user.id).distinct
      temp_ids.each do |temp_id|
        save_notification_review(current_user, gunpla_id, temp_id["user_id"])
      end
      save_notification_review(current_user, gunpla_id, user_id) if temp_ids.blank?
    end

    def save_notification_review(current_user, gunpla_id, visited_id)
      notification = current_user.active_notifications.build(
        gunpla_id: gunpla_id,
        review_id: id,
        visited_id: visited_id,
        action: "review"
      )
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end

    # レビューコメント
    def create_notification_comment(current_user, comment_id)
      temp_ids = Comment.select(:user_id).where(review_id: id).where.not(user_id: current_user.id).distinct
      temp_ids.each do |temp_id|
        save_notification_comment(current_user, comment_id, temp_id["user_id"])
      end
      save_notification_comment(current_user, comment_id, user_id) if temp_ids.blank?
    end

    def save_notification_comment(current_user, comment_id, visited_id)
      notification = current_user.active_notifications.build(
        review_id: id,
        comment_id: comment_id,
        visited_id: visited_id,
        action: "comment"
      )
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end
end
