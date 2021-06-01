class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  has_many :delivery_addresses, dependent: :destroy
  has_many :orders, dependent: :destroy

  enum role: {customer: 0, admin: 1}

  attr_accessor :activation_token

  validates :name, presence: true,
            length: {maximum: Settings.user.name_max_len}
  validates :password, presence: true,
    length: {minimum: Settings.user.pwd_min_len},
    allow_nil: true
  validates :email, presence: true,
            length: {maximum: Settings.user.email_max_len},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  before_save{email.downcase!}
  before_create :create_activation_digest

  scope :active, ->{where activated: true}

  class << self
    def digest string
      cost = BCrypt::Engine.cost
      cost = BCrypt::Engine::MIN_COST if ActiveModel::SecurePassword.min_cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
