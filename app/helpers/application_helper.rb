module ApplicationHelper
  def full_title(sub_title: nil)
    if sub_title.present?
      "#{sub_title} - #{MAIN_TITLE}"
    else
      MAIN_TITLE
    end
  end

  def default_meta_tags(sub_title: nil)
    {
      title: "#{full_title(sub_title: sub_title)}",
      charset: "utf-8",
      reverse: true,
      description: "Gunpla-Typeは、レビューやブックマーク、ランキングなどの機能を活用し、ガンプラを通してユーザー同士が共有を楽しむためのWEBサービスです。",
      keywords: "ガンプラ,レビュー,口コミ,ランキング",
      icon: [
        { href: image_url("favicon.ico") },
      ],
      og: {
        title: :title,
        description: :description,
        type: "website",
        url: request.original_url,
        locale: "ja_JP",
      },
    }
  end

  def current_user?(user)
    user&. == current_user
  end
end
