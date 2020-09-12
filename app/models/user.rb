class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :timeoutable, :trackable,
         :omniauthable, omniauth_providers: [:facebook, :twitter, :google_oauth2]

  class << self
    def find_for_oauth(auth)
      user = User.where(uid: auth.uid, provider: auth.provider).first
      user ||= User.create(
        uid: auth.uid,
        provider: auth.provider,
        email: User.dummy_email(auth),
        password: Devise.friendly_token[0, 20],
        name: auth.info.name,
        image: auth.info.image
      )
      user
    end

    protected

    def dummy_email(auth)
      "#{auth.uid}-#{auth.provider}@example.com"
    end
  end
end
