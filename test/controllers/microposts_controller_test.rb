require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  #先测试
  def setup
    @micropost = microposts(:orange)
  end 
  
  #create 
  test "should redirect create when not login" do
    assert_no_difference 'Micropost.count' do 
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end 
    assert_redirected_to login_url
  end
  #destroy
  test "should redirect destroy when not login" do
    assert_no_difference 'Micropost.count' do 
      delete micropost_path(@micropost)
    end 
    assert_redirected_to login_url
  end
  
  #微博则要求只有发布人自己才能删除
  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost) 
    end
    assert_redirected_to root_url
  end
end
