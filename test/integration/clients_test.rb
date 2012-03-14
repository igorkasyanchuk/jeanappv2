require 'test_helper'

class ClientsTest < ActionController::IntegrationTest

  test "could create new client" do
    user = Factory(:user)
    login_as(user)
    click_link "Clients"
    click_link "Add Client"
    fill_in "client_name", :with =>"super_client"
    click_button "Create"
    assert page.has_content?("Projects: 0")
    assert page.has_content?("Empoyees: 0")
    assert page.has_content?("List is empty.")
  end

end
