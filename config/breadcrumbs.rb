crumb :root do
  link "ホーム", root_path
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
end

crumb :gunpla_list do
  link "ガンプラ一覧", gunplas_path
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
