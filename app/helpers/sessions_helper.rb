module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end 
  #返回当前用户 nil用User.find_by
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])
      #if user && user.authenticated?(cookies[:remember_token])
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end 
    end 
  end
  
  def logged_in?
    !current_user.nil?
  end 
  
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end 
  
  
  #持久会话中记住用户
  #用模型中方法
  # user.remember，从而生成一个记忆令牌，并把对应的摘要 存入数据库;然后使用 cookies 创建持久的 cookie，保存用户 ID 和记忆令牌
  def remember(user)
    user.remember
    #用户 ID 和持久记忆令牌配对，所以也要持久存储用户 ID
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end 
  
  #forget 方法先调用 user.forget，然后再从 cookie 中删除 user_id 和 remember_token。
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end 
  
  #用户是否是当前用户在操作, 防止nil
  def current_user?(user)
    user && user == current_user
  end 
  
  # 重定向到存储的地址或者默认地址
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end 
  
  #存储后来需要使用的网址
  def store_location
    #使用 session 存储转向地址
    # request 对 象，获取所请求页面的地址(request.original_url)
    session[:forwarding_url] = request.original_url if request.get?
    #session[:forwarding_url] = request.original_url 
  end 
end
