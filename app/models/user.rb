class User < ApplicationRecord
  before_save :downcase_email

  validates :email, presence: true, uniqueness: true,
  length: {maximum: Settings.validate.email.length.max},
  format: {with: Regexp.new(Settings.validate.email.regex)}

  validates :name, presence: true,
  length: {maximum: Settings.validate.name.length.max}

  has_secure_password
  validates :password, presence: true,
  length: {minimum: Settings.validate.password.length.min}

  attr_accessor :remember_token

  class << self
    # Returns the hash digest of the given string.
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  private

  def downcase_email
    email.downcase!
  end
end
