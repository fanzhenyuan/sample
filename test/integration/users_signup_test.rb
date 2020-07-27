require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    #deliveries 是一个数组，用于统计所有发出的邮件，所以我们要在 setup
    #方法中把它清空，以防其他测试发送了邮件
    ActionMailer::Base.deliveries.clear
  end 
  
  #注册失败
  test "signup error" do
    get signup_path
    #可以不渲染
    assert_template 'users/new'
    #查看数量
    assert_no_difference 'User.count' do
      post users_path, params: { user: {  name: "",
                                          email: "user@invalid",
                                          password: "foo",
                                          password_confirmation: "bar" } }
    end 
    #render
    assert_template 'users/new'
    #显示错误信息
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end
  
  #注册成功
  test "right signup" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "fanfanfan",
                                         email: "user@example.com",
                                         password: "password",
                                         password_confirmation: "password" }}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # 尝试在激活之前登录
    log_in_as(user)
    assert_not is_logged_in?
    #激活令牌无效
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # 令牌有效，电子邮件地址不对
    get edit_account_activation_path(user.activation_token, email: "wrong")
    assert_not is_logged_in?
    
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    #follow_redirect! 方法跟踪重定向，渲染 users/show 模板
    follow_redirect!
    
    #现在重定向到根地址而不是资料页面，而且不会像之前那样自动登入用户，所以测试组件无法通过
    assert_template 'users/show'
      #测试闪现消息不为空
    #assert_not flash.empty?
      #测试组册后自动登录
    assert is_logged_in?
  end
end
