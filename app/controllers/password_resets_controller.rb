class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update] 
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  #修改超时
  before_action :check_expiration, only: [:edit, :update]

  def new
  end 
  
  def create 
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions" 
      redirect_to root_url
    else
      #1
      flash.now[:danger] = "Email address not found"
      render 'new'
    end 
  end

  def edit
  end
  
    
  #密码重设请求已过期
  #填写的新密码无效，更新失败
  #没有填写密码和密码确认，更新失败(看起来像是成功了)
  #成功更新密码
  def update
    #3
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    #4
    elsif @user.update(user_params)
      log_in(@user)
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "ok"
      redirect_to @user 
    else
      #2
      render 'edit'
    end 
  end        

  
  private
    
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    def valid_user
      unless (@user && !!@user.activated? && @user.authenticated?(:reset, params[:id])) 
        redirect_to root_url
      end
    end 
    
    #检查是否过期
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end 
    end
    
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end 
    
end
