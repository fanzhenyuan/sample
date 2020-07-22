class ApplicationController < ActionController::Base
  #controller引入helper  views不需要引入
  #在 Application 控制器中引入 Sessions 辅助模块
  include SessionsHelper
end
