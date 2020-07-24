ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters" 
require 'simplecov'
SimpleCov.start
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  #引入helper full_title方法
  include ApplicationHelper

  #引入helper 与logged_in? 一样
  def is_logged_in?
    !session[:user_id].nil?
  end 
  
  #在控制器测试中可以直接使用 session 方法
  def log_in_as(user)
    session[:user_id] = user.id
  end 
end 
  
#在集成测试中不能直接使用 session 方法
#相同的名称在两个地方定义方法，这样控制器测试中的代码不经修改就能在集成测试中使用。
class ActionDispatch::IntegrationTest
  #相同的名称在两个地方定义方法，这样控制器测试中的代码不经修改就能在集成测试中使用。
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me
    }}
  end 
end
