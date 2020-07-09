class UsersController < ApplicationController
  #注册页
  def new
    @user = User.new
  end
  #注册内部
  def create
    @user = User.new(user_params)
    if @user.save
      #访问随后的页面时显示一个消息
      #它生成的htm是 <div class="alert alert-success">Welcome</div>
      #flash-Hash传入appli 模版
      flash[:success] = "WELCOME!"
      # 重定向 redirect_to user_url(@user)
      redirect_to user_url(@user)
    else
      #new action 传入@user
      render 'new'
    end 
  end
  #健壮参数
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end 
  
  def show
    #params[:id] 返回的是字符串 "1"，不过 find 方法会自动将其转换成整数。
    @user = User.find(params[:id])
    #debugger
  end 
end
