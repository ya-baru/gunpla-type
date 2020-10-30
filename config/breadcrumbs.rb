crumb :root do
  link "ホーム", root_path
end

crumb :notification do
  link "お知らせリスト", notifications_path
end

crumb :activity do
  link "アクティビティー", activities_path
end

crumb :ranking do
  link "ランキング", rankings_path
end

crumb :company do
  link "運営情報", company_path
end

crumb :privacy do
  link "プライバシーポリシー", privacy_path
end

crumb :term do
  link "利用規約", term_path
end

crumb :questions do
  link "よくある質問", questions_path
end

crumb :contacts do
  link "お問い合わせ", new_user_contact_path
end

crumb :contact_confirm do
  link "送信確認", contact_confirm_path
  parent :contacts
end

crumb :signup do
  link "新規登録", new_user_registration_path
end

crumb :signup_confirm do
  link "確認画面", signup_confirm_path
  parent :signup
end

crumb :signin do
  link "ログイン", new_user_session_path
end

crumb :mypage do |user|
  link "マイページ", mypage_path(user)
end

crumb :like_reviews do |user|
  link "いいね！レビューリスト", like_reviews_mypage_path(user)
end

crumb :favorite_gunplas do |user|
  link "お気に入りガンプラリスト", favorite_gunplas_mypage_path(user)
end

crumb :following do |user|
  link "フォローリスト", following_mypage_path(user)
end

crumb :followers do |user|
  link "フォロワーリスト", followers_mypage_path(user)
end

crumb :profile_edit do |user|
  link "プロフィール編集", edit_user_registration_path(user)
  parent :mypage, user
end

crumb :password_edit do |user|
  link "パスワード編集", edit_password_user_registration_path(user)
  parent :mypage, user
end

crumb :email_edit do |user|
  link "メールアドレス編集", edit_email_user_registration_path(user)
  parent :mypage, user
end

crumb :signout_confirm do |user|
  link "退会の手続き", signout_confirm_path
  parent :mypage, user
end

crumb :unlock do
  link "アカウント凍結解除の方法", new_account_unlock_path
end

crumb :password do
  link "パスワード再設定の方法", new_reset_password_path
end

crumb :account_confirmation do
  link "確認メール再送信", new_account_confirmation_path
end

crumb :gunpla_up do
  link "ガンプラ登録", new_gunpla_path
  parent :gunpla_list
end

crumb :gunpla_update do |gunpla|
  link "ガンプラ編集", edit_gunpla_path(gunpla)
  parent :gunpla, gunpla
end

crumb :gunpla_list do
  link "ガンプラリスト", gunplas_path
end

crumb :gunpla_search do
  link "検索結果", search_gunplas_path
  parent :gunpla_list
end

crumb :category_search do
  link "カテゴリー検索", select_category_index_gunpla_path
  parent :gunpla_list
end

crumb :gunpla do |gunpla|
  link gunpla.name, gunpla_path(gunpla)
  parent :gunpla_list, gunpla
end

crumb :review do |review|
  link "レビュー詳細", review_path(review)
  parent :gunpla, review.gunpla
end

crumb :review_up do |gunpla|
  link "レビュー投稿", new_gunpla_review_path(gunpla)
  parent :gunpla, gunpla
end

crumb :review_update do |review|
  link "レビュー編集", edit_review_path(review)
  parent :review, review
end
# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
