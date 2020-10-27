class User < ApplicationRecord
  include Omniauth
  include Avatar
  include LikeReview
  include FavoriteGunpla
  include Follow
  include NotificationCreate

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
  has_many :favorites, dependent: :destroy
  has_many :favorite_gunplas, through: :favorites, source: :gunpla
  has_many :active_relationships,
           class_name: "Relationship",
           foreign_key: "follower_id",
           dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships,
           class_name: "Relationship",
           foreign_key: "followed_id",
           dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :comments, dependent: :destroy
  has_many :active_notifications, class_name: "Notification", foreign_key: "visitor_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy

  validates :username, presence: true, length: { maximum: 20 }
  validates :profile, length: { maximum: 255 }
  validates :email, length: { maximum: 255 }
  validates :email, confirmation: true, on: :change_email
  validates :email_confirmation, presence: true, on: :change_email
  validates :password, format: { with: VALID_PASSWORD_REGEX }
  validate :avatar_type, :avatar_size
end
