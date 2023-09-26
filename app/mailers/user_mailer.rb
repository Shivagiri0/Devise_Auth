class UserMailer < ApplicationMailer
  def suspicious_login_notification(user)
    @user = user
    mail(to: user.email, subject: 'Suspicious Login Attempt')
  end
end