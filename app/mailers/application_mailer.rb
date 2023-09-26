class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@email.com'
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to this MyApp Site')
  end
end