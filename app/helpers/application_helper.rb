module ApplicationHelper
  def full_title(sub_title: nil)
    if sub_title.present?
      "#{sub_title} - #{MAIN_TITLE}"
    else
      MAIN_TITLE
    end
  end

  def current_user?(user)
    user&. == current_user
  end
end
