require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full_title" do
    assert_equal full_title("Contact"), "Contact | Ruby on Rails"
    assert_equal full_title, "Ruby on Rails"
  end
end 