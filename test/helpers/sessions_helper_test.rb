# log_in_as 辅助方法自动设定了 session[:user_id]，所以在集成测试中测试 cur- rent_user 方法的“记住”分支很难
#幸好我们可以跳过这个限制，在 Sessions 辅助模块的测试中直接测试 current_user 方法
require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  #直接用SessionsHelper方法
  def setup
    @user = users(:michael) 
    remember(@user)
  end
  
  test "current_user returns right user when session is nil" do 
    assert_equal @user, current_user
    assert is_logged_in?
  end
  
  test "current_user returns nil when remember digest is wrong" do 
    @user.update_attribute(:remember_digest, User.digest(User.new_token)) 
    #记忆摘要和记忆令牌不匹配时当前用户是 nil
    assert_nil current_user
  end
end 