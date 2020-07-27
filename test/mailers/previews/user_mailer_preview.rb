# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  #mailers user_mailer  中account_activation 方法需要一个有效的用户作为参数
  def account_activation
    user = User.first
    #模板要使用账户激 活令牌
    user.account_activation = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    UserMailer.password_reset
  end

end
