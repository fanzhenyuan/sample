class ApplicationController < ActionController::Base
  def hello
    render html: "go"
  end 
end
