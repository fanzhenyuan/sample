require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end 
  #微博界面的集成测试
  test "should" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    #assert_select 'input[type=hidden]'
    #无效提交
    assert_no_difference 'Micropost.count' do 
      post microposts_path, params: { micropost: {content: "" } }
    end
    assert_select 'div#error_explanation'
    assert_select 'a[href=?]', '/?page=2'
    # 有效提交
    content = "fffyyy"
    #在测试中上传固件中的文件使 用的是专门的 fixture_file_upload 
    image = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg')
    assert_no_difference 'Micropost.count' do 
      post microposts_path, params: { micropost:
                                      { content: content,
                                        image: image } }
    end 
    #assigns 方法，在提交成功后获取 create 动作中的 @micropost 变量
    assert assigns(:micropost).image.attached?
    #assert_redirected_to root_url 
    #follow_redirect!
    assert_match content, response.body
    #删除一片微博
    assert_select 'a', text: 'delete'
    first = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do 
      delete micropost_path(first)
    end 
    #另一个页面没有删除连接
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
   end
   
   test "sidebar" do
     log_in_as(@user)
     get root_url
     assert_match "#{@user.microposts.count} microposts", response.body
     #没有发布weobo的用户
     other_user = users(:malory) 
     log_in_as(other_user)
     get root_path
     assert_match "0 microposts", response.body
     other_user.microposts.create!(content: "asd")
     #进入主页查看
     get root_path
     assert_match "1 micropost", response.body
   end
end
