require 'test_helper'

class UsersTest < ActionController::IntegrationTest

  test "login" do
    user = Factory(:user)
    login_as(user)
    assert page.has_content?('Projects')
    assert page.has_content?('Employees')
    assert page.has_content?('Clients')
    click_link "Profile"
    assert page.has_content?("Edit Profile")
  end
  
end
