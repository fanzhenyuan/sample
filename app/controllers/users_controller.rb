class UsersController < ApplicationController
  #class内方法: 
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  #只允许管理员删除用户。
  before_action :admin_user, only: [:destroy]
  
  def index
    #@user = User.all fenye
    #params 中的这个键由 will_pagenate 自动生成。
    #只显示已激活用户的代码模板
    @users = User.where(activated: true).paginate(page: params[:page])
  end 
  
  def show
    #params[:id] 返回的是字符串 "1"，不过 find 方法会自动将其转换成整数。
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
  end
  
  #注册页
  def new
    @user = User.new
  end
  
  #注册内部
  #因为现在重定向到根地址而不是资料页面，不会像之前那样自动登入用户，
  #所以测试组件无法通过，不过应用能按照我们设计的方式运行。我们暂时把导致失败的测试注释掉
  def create
    @user = User.new(user_params)
    if @user.save
      #访问随后的页面时显示一个消息
      #它生成的htm是 <div class="alert alert-success">Welcome</div>
      #flash-Hash传入appli 模版
      #重新请求
      
      #最开始 注册后登录
      #log_in(@user)
      #flash[:success] = "WELCOME!"
      # 重定向 redirect_to user_url(@user)
      #redirect_to @user
      
      #把处理用户的代码从控制器中移出， 放入模型
      @user.send_activation_email
      
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      #new action 传入@user
      render 'new'
    end 
  end
  

  
  def edit
    #@user = User.find(params[:id])
  end 
  
  def update
    #@user = User.find(params[:id])
    #防止批量赋值带来的隐患
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    elsif 
      render 'edit'
    end     
  end
  
  #权限,没登录时候要去登录
  def logged_in_user
    unless logged_in?
      #存储
      store_location
    
      flash[:danger] = "Please log in."
      redirect_to login_url
    end 
  end 
  
  #重定向到试图编辑其他用户资料的用户
  def correct_user
    #edit update的@user删掉
    @user = User.find(params[:id])
    #redirect_to(root_url) unless @user == current_user
    redirect_to(root_url) unless current_user?(@user)
  end 
  
  
  def destroy
    #找到所要删除的用户
    #然后使用 Active Record 提供的 destroy 方法将其删除
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end 
  
  def admin_user
    redirect_to(root_url) unless current_user.admin? 
  end
  
  #健壮参数
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end 
  
end
