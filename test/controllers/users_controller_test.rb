require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
#确保用户不能编辑其他用户的信息，我们需要登入第二个用户 固件  
  def setup
    @base_title = "Ruby on Rails"
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
    assert_select "title", "Sign-up | #{@base_title}"
  end
  
  #beaction edit 去掉后还可以通过,所以测试
  #不登录不让进
  test "login_path when no login-edit" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  # #beaction update 去掉后还可以通过,所以测试
  test "login_path when no login-update" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email
    } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "user login edit other_user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "user login update other_user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { email: @user.email,
                                              name: @user.name
    }}
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  #没登录,不能查看所有用户, beforeaction + index
  test "no login no index sehen" do
    get users_path
    assert_redirected_to login_url
  end
  
  #测试admin不可修改
  test "admin can not edit" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: { user: { password: "password",
                                                    password_confirmation: "password",
                                                    admin: true } }
    assert_not @other_user.reload.admin?
  end
  
  
  #没登录的用 户会重定向到登录页面
  test "destroy when not login" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end 
    assert_redirected_to login_url
  end
  #已经登录的用户，但不是管理员，会重定向到首页
  test "destroy when no admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end 
    assert_redirected_to root_url
  end
end
