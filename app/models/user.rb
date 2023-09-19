class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :refresh_tokens, dependent: :delete_all
  has_many :whitelisted_tokens, dependent: :delete_all
  has_many :blacklisted_tokens, dependent: :delete_all
  validate :password_not_common
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :trackable,
         :lockable,
         :omniauthable, omniauth_providers: [:google_oauth2, :github]

  attr_accessor :active

  enum role: { user: 0, admin: 1 }

  after_initialize :set_default_role, :if => :new_record?
  def set_default_role
    self.role ||= :user
  end

  def self.from_omniauth(access_token)
    user = User.where(email: access_token.info.email).first
    unless user
      user ||= User.create(email: access_token.info.email, password: Devise.friendly_token[0, 20])
    end
    user
  end

  private

  def password_not_common
    common_passwords = [
      'password', '123456', 'qwerty', 'abc123'
    ]
    if common_passwords.include?(password)
      errors.add(:password, 'Please choose a stronger password.')
    end
  end
end
