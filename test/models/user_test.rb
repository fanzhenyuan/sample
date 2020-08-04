require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
      # has_secure_password会在 password 和 password_confirmation 两个虚拟属性上执行验证
      # 创建 @user 变量时没有设定这两个属性
      @user = User.new( name: "fan", email: "fanyfan2020@hotmail.com",
                       password: "footbar", password_confirmation: "footbar" )
  end 
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be presence" do
    @user.name = "    "
    assert_not @user.valid?
  end
  
  test "email should be presence" do
    @user.email = "    "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a" * 244 + "@hotmail.com"
    assert_not @user.valid?
  end
  #Email
  test "email valid" do
    valid_adds = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                   first.last@foo.jp alice+bob@baz.cn]
    valid_adds.each do |valid_add|
      @user.email = valid_add
      assert @user.valid?, "#{valid_add} valid"
    end 
  end
  
  test "email invalid" do
    invalid_adds = %w[user@example,com user_at_foo.org user.name@example.
                      foo@bar_baz.com foo@bar+baz.com]
    invalid_adds.each do |invalid_add|
      @user.email = invalid_add
      assert_not @user.valid?, "#{invalid_add} invalid"
    end 
  end
  #Email唯一性的 无效
  test "email should be unique" do
    duplicate_user = @user.dup 
    #测试不区分大小写
    #duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  #转换小写测试
  test "before_save downcase" do
    mixed = "FanYfaN@hotmail.com"
    @user.email = mixed
    @user.save
    assert_equal mixed.downcase, @user.reload.email 
  end
  #invalid  pass no blank
  test "password no blank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  #invalid  pass min 6
  test "password min 6" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  #不同的浏览器，在集成测试中很难模拟，不过直接在 User 模型层测试很简单
  #cookie 中的用户 ID 仍然存在
  # 2浏览器 一个退出 一个关闭在打开，digest变nil了，BCrypt::Password.new(nil) 会抛出异常，所以测试组件不能通过:
  #空记忆令牌，因为还没用到这个值之前就会发生错误
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end 
  
  test "destroy mir delete" do
    @user.save
    @user.microposts.create!( content: "asd")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end 
  end
end
