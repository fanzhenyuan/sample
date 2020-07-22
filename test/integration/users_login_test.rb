require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    #users 对应固件文件 users.yml 的文件名，:michael 是代码清单 8.23 中定义的用户。
    @user = users(:michael)
  end 
  
  #测试成功登录
  test "invalid login" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: {email: "", password: ""}}
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    #访问一个其他页面,不先死闪现
    get root_path
    assert flash.empty?
  end
  
  #测试登录布局中的变化
  test "anderung der login und layout" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password'
    }} 
    assert is_logged_in?
    #assert_redirected_to @user检查重定向的地址是否正确;使用follow_redirect! 访问重定向的目标地址
    assert_redirected_to @user 
    follow_redirect!
    assert_template 'users/show'
    assert_select "[href=?]", login_path, count: 0
    assert_select "[href=?]", logout_path
    assert_select "[href=?]", user_path(@user)
    
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0 
    assert_select "a[href=?]", user_path(@user), count: 0
  end
  
  
  #电子邮件地址正确 而密码错误的情况
  test "valid email invalid password" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'inva'
    }}
    # 没有成功登录 然后测试渲染
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  #测试退出
  test "destroy action" do
    
  end
end
