class ApplicationController < ActionController::Base
  #controller引入helper  views不需要引入
  #在 Application 控制器中引入 Sessions 辅助模块
  include SessionsHelper
  
  #usercontroller里的 需要在micropost控制中使用
  private
    #权限,没登录时候要去登录
    def logged_in_user
      unless logged_in?
        #存储
        store_location
      
        flash[:danger] = "Please log in."
        redirect_to login_url
      end 
    end 
end
