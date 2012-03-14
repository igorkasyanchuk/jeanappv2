require 'test_helper'

class HomesTest < ActionController::IntegrationTest

  test "test home page" do
    visit root_path
    assert page.has_content?('Login')
  end
  
end
