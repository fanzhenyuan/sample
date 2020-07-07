require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout root" do
    get root_path
    #views home
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", contact_path
    #contact页面
    get contact_path
    assert_select "title", full_title("Contact")
    #signup页面
    get signup_path
    assert_select "title", full_title("Sign-up")
  end 
end
