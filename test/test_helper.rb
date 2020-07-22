ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters" 
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
end
