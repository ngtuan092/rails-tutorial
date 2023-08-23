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

  private

  def downcase_email
    email.downcase!
  end
end
