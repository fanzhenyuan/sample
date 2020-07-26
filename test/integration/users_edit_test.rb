#编辑失败的测试
require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end 
  
  test "unsuccess edit" do
    #edit需要登录
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                       email: "foo@invalid",
                                       password: "foo",
                                       password_confirmation: "bar"
    } }
    assert_template 'users/edit'
    assert_select "div.alert", "The form contains 4 errors."
  end
  
  #编辑成功测试tdd
  test "success edit with friendly" do
    #登录后回到出事像访问的页面
    #最终写出的测试先访问编辑页面，然后登录，
    #最后确认把用户重定向到了编辑页面
    get edit_user_path(@user)
    log_in_as(@user)
    #get edit_user_path(@user)
    #assert_template 'users/edit'
    assert_redirected_to edit_user_url(@user)
    name = "ffff"
    email = "ffff@qq.com"
    patch user_path(@user), params: { user: { name: name,
                                       email: email,
                                       password: "",
                                       password_confirmation: ""
    }}
    assert_not flash.empty?
    assert_redirected_to @user
    follow_redirect!
    assert_equal name, @user.reload.name
    assert_equal email, @user.reload.email
  end
end
