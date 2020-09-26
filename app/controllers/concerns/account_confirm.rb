module AccountConfirm
  extend ActiveSupport::Concern
  included do
    def account_unconfirm
      flash[:danger] = "アカウントが有効化されていません。<br>メールに記載された手順にしたがって、アカウントを有効化してください。".html_safe
      redirect_to root_url
    end
  end
end
