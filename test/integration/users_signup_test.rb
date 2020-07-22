require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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
    #follow_redirect! 方法跟踪重定向，渲染 users/show 模板
    follow_redirect!
    assert_template 'users/show'
    #测试闪现消息不为空
    assert_not flash.empty?
    #测试组册后自动登录
    assert is_logged_in?
  end
end
