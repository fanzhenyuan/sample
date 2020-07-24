class SessionsController < ApplicationController
  def new
  end
  
  # create 动作中定 义了 @user 变量，在测试中可以使用 assigns(:user) 获取这个变量
  def create
    #电子邮件地址都是以小写字母形式保存的，所以这里调用了 downcase 方法，
    #确保提交有效的地址后能查到相应的记录
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      log_in(@user)
      #user_url(user)
      #现在可以记住用户的登录状态了。我们要在 log_in 后面调用 remember 辅助方法
      #remember user 
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_to @user 
    else
      #会话不是 Active Record 模型
      #而重新渲染页面(使用 render 方法)与重定向不同，不算是一次新请求
      #.now 下次闪现小时
      flash.now[:danger] = 'invalid email/password'
      render 'new'
    end 
  end
  #退出 重定向到根地址 现在测试退出功能
  def destroy
    #如果用户在一个窗􏰃中退出了，再在􏰀一个窗􏰃中点击退出链接的 话会导致错误
    #log_out 方法中使用了 forget(current_user)
    log_out if logged_in?
    redirect_to root_url
  end 
end
