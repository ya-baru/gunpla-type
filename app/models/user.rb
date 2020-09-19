class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :lockable,
         :timeoutable,
         :trackable,
         :omniauthable, omniauth_providers: [:facebook, :twitter, :google_oauth2]

  has_one_attached :avatar, dependent: :destroy

  validates :username, presence: true, length: { maximum: 20 }
  validates :profile, length: { maximum: 255 }
  validates :email, length: { maximum: 255 }
  validates :email, confirmation: true, on: :change_email
  validates :email_confirmation, presence: true, on: :change_email
  validates :password, format: { with: VALID_PASSWORD_REGEX }
  validates :avatar,
            content_type: {
              in: %w(image/jpg image/jpeg image/png),
              message: "のファイル形式が有効ではありません。",
            },
            size: {
              less_than: 3.megabytes, message: "のファイルサイズは3MBです。",
            }

  def display_avatar
    avatar.variant(resize_to_limit: [150, 150])
  end

  class << self
    def find_for_oauth(auth)
      user = User.where(uid: auth.uid, provider: auth.provider).first
      user ||= User.new( # rubocop:disable Lint/UselessAssignment
        uid: auth.uid,
        provider: auth.provider,
        username: auth.info.name,
        image: auth.info.image,
        email: User.dummy_email(auth),
        password: Devise.friendly_token[0, 20]
      )
    end

    protected

    def dummy_email(auth)
      "#{auth.uid}-#{auth.provider}@example.com"
    end
  end
end
