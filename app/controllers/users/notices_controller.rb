class Users::NoticesController < ApplicationController
  before_action :login_user

  def account_confirm
    @message1 = "本人確認用のメールを送信しました。"
    @message2 = "メール内のリンクからアカウントを有効化させてください。"
    render :mail_sent
  end

  def password_reset
    @message1 = "メールアドレスを確認しました。"
    @message2 = "パスワードの再設定について数分以内にメールでご連絡いたします。"
    render :mail_sent
  end

  def unlock
    @message1 = "メールアドレスを確認しました。"
    @message2 = "アカウントの凍結解除方法を数分以内にメールでご連絡します。"
    render :mail_sent
  end
end
