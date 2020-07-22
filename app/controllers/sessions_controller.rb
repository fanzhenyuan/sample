class SessionsController < ApplicationController
  def new
  end
  
  def create
    #电子邮件地址都是以小写字母形式保存的，所以这里调用了 downcase 方法，
    #确保提交有效的地址后能查到相应的记录
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      #user_url(user)
      redirect_to user 
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
    log_out
    redirect_to root_url
  end 
end
