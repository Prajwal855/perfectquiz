class UserMailer < ApplicationMailer
    default from: 'no-reply@gmail.com' # Change to your email address

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to our site!') do |format|
        format.text { render plain: 'Welcome to our site!' }
    end
   end
end
