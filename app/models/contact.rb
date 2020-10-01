class Contact < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  validates :message, presence: true, length: { maximum: 1000 }
end
