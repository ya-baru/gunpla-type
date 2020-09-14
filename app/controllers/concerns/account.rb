module Account
  extend ActiveSupport::Concern
  included do
    def account_confirmed
      flash[:danger] = "アカウントが有効化されていません。メールに記載された手順にしたがって、アカウントを有効化してください。"
      redirect_to root_url
    end
  end
end
