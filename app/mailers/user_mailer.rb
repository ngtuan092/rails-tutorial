class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation user
    @user = user

    mail to: user.email,
         subject: t("mailers.user_mailer.account_activation.subject")
  end

  def password_reset user
    @user = user

    mail to: user.email,
         subject: t("mailers.user_mailer.password_reset.subject")
  end
end
