require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    # 这行代码不符合习惯做法
    #@micropost = Micropost.new(content: "aaa", user_id: @user.id)
    @micropost = @user.microposts.build(content: "Loremipsum", user_id: @user.id)
  end 
  
  #TDD ok's
  test "micropost should be valid" do
    assert @micropost.valid?
  end
  
  #userid不能为空
  test "user_id should be presence" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  #content不能唯恐
  test "content should be presence" do
    @micropost.content = "  "
    assert_not @micropost.valid?
  end
  
  test "content<140" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
end
