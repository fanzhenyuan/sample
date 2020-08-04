class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy 
  
  def create 
    #返回一个 user 发布的新微博对象
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "ok"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end 
  end
  
  def destroy 
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    #因为首页和资料页面都有微博，
    #我们使用 request.referrer 把用户重定向到发 起删除请求的页面
    #equest.referrer 为 nil(例如在某些测试中)，就转向 root_url
    redirect_to request.referrer || root_url
  end 
  
  private
  
    def micropost_params
      params.require(:micropost).permit(:content, :image)
    end
    
    #删除微博时,如果不是当下用户这转到首页
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end 
end
