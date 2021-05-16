class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  has_many :delivery_addresses, dependent: :destroy
  has_many :orders, dependent: :destroy

  enum role: {customer: 0, admin: 1}

  has_secure_password
  validates :name, presence: true,
            length: {maximum: Settings.user.name_max_len}
  validates :password, presence: true,
    length: {minimum: Settings.user.pwd_min_len},
    allow_nil: true
  validates :email, presence: true,
            length: {maximum: Settings.user.email_max_len},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
end
