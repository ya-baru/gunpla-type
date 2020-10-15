module Users::GunplaHelper
  def header_title(title, count)
    "#{title}（#{count}）"
  end

  def search_keyword
    if current_page?(search_gunplas_path) && params[:q][:name_cont].present?
      "『#{params[:q][:name_cont]}』"
    end
  end

  def none_search_result
    concat content_tag(:strong, "『#{params[:q][:name_cont]}』")
    content_tag(:span, "に一致するガンプラはありませんでした。")
  end
end
