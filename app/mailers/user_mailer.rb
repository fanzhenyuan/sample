class UserMailer < ApplicationMailer

  
  #创建一个实例变量，其值是用户对象，以便在视图中使用
  def account_activation(user)
    @user = user 
    #subject 参数，指定邮件的主题。
    mail to: @user.email, subject: "aktiv"
  end
  #测试无法通过(由于我们修改了 account_activation 方法，让它接受一 个参数)
  
  
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user 

    mail to: @user.email, subject: "password_reset"
  end
end
