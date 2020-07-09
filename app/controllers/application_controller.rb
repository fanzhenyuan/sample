class ApplicationController < ActionController::Base
  #controller引入helper  views不需要引入
  include UsersHelper
  
end
