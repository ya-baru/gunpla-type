module NotificationCreate
  extend ActiveSupport::Concern
  included do
    # フォロー
    def create_notification_follow(current_user)
      temp = Notification.where(
        ["visitor_id = ? and visited_id = ? and action = ?", current_user.id, id, "follow"]
      )
      if temp.blank?
        notification = current_user.active_notifications.build(
          visited_id: id,
          action: "follow"
        )
        notification.checked = true unless notification.visited.notice?
        visited_history_delete(visited: id)
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
        notification.checked = true unless notification.visited.notice?
        visited_history_delete(visited: user_id)
        notification.save if notification.valid?
      end
    end

    # お気に入りレビュー
    def create_notification_review(current_user, gunpla_id)
      temp_ids = Favorite.select(:user_id).where(gunpla_id: gunpla_id).where.not(user_id: current_user.id)
      temp_ids.each do |temp_id|
        save_notification_review(current_user, gunpla_id, temp_id["user_id"])
      end
      save_notification_review(current_user, gunpla_id, current_user.id)
    end

    def save_notification_review(current_user, gunpla_id, visited_id)
      notification = current_user.active_notifications.build(
        gunpla_id: gunpla_id,
        review_id: id,
        visited_id: visited_id,
        action: "review"
      )
      notification.checked = true unless notification.visited.notice?
      notification.checked = true if notification.visitor_id == notification.visited_id
      visited_history_delete(visited: visited_id)
      notification.save if notification.valid?
    end

    # レビューコメント
    def save_notification_comment(current_user, review_id, visited_id)
      notification = current_user.active_notifications.build(
        review_id: review_id,
        comment_id: id,
        visited_id: visited_id,
        action: "comment"
      )
      notification.checked = true unless notification.visited.notice?
      notification.checked = true if notification.visitor_id == notification.visited_id
      visited_history_delete(visited: visited_id)
      notification.save if notification.valid?
    end
  end

  private

  def visited_history_delete(visited: nil)
    visited_histories = Notification.where(visited_id: visited)
    visited_histories.first.destroy if visited_histories.count > VISITEDE_STOCK_LIMIT
  end
end
