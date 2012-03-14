require 'test_helper'

class EmployeesTest < ActionController::IntegrationTest

  test "could create new employee" do
    user = Factory(:user)
    login_as(user)
    click_link "Employees"
    click_link "Add new Employee"
    fill_in "person_first_name", :with =>"PFN"
    fill_in "person_last_name", :with =>"PFN"
    fill_in "person_email", :with =>"email@email.com"
    fill_in "person_hourly_rate", :with => "20"
    click_button "Create"
    assert page.has_content?("Projects History")
    assert page.has_content?("Edit")
    assert page.has_content?("Notes")
    click_link "Employees"
    assert page.has_content?("PFN")
    assert page.has_content?("Workload")
  end

end
