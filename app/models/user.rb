class User < ApplicationRecord
  include Omniauth
  include Avatar
  include Iine

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
  has_many :browsing_histories, dependent: :destroy
  has_many :gunpla_histories, through: :browsing_histories, source: :gunpla
  has_many :reviews, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :iine_reviews, through: :likes, source: :review

  validates :username, presence: true, length: { maximum: 20 }
  validates :profile, length: { maximum: 255 }
  validates :email, length: { maximum: 255 }
  validates :email, confirmation: true, on: :change_email
  validates :email_confirmation, presence: true, on: :change_email
  validates :password, format: { with: VALID_PASSWORD_REGEX }
  validate :avatar_type, :avatar_size
end
