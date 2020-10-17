module Users::GunplaHelper
  def header_title(title, count)
    "#{title}（#{count}）"
  end

  def search_result
    if current_page?(search_gunplas_path) && params[:q][:name_cont].present?
      content_tag(:div, "『#{params[:q][:name_cont]}』", class: "search_result")
    end
  end

  def none_search_result
    content_tag(:div, class: "search_result") do
      concat content_tag(:strong, "『#{params[:q][:name_cont]}』")
      concat content_tag(:span, "に一致するガンプラはありませんでした。")
    end
  end
end
