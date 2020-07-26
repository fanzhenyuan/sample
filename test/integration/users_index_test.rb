require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
    @no_admin = users(:archer)
  end 
  #分页测试. 管理员执行的删除操作
  test "index inclusic paginate und + delete" do
    #get login_path
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    first = User.paginate(page: 1)
    first.paginate(page: 1).each do |user|
      #可以有text
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end 
    end 
    assert_difference 'User.count', -1 do
      delete user_path(@no_admin)
    end 
  end
  
  #非管理员登录 看不到delete
  test "destroy no-admin" do
    log_in_as(@no_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
