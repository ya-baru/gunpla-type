module ApplicationHelper
  def full_title(sub_title: nil)
    if sub_title.present?
      "#{sub_title} - #{MAIN_TITLE}"
    else
      MAIN_TITLE
    end
  end
end
