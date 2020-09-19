class NoticesController < ApplicationController
  before_action :signed_in?

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

  private

  def signed_in?
    return redirect_to root_path if user_signed_in?
  end
end
