require 'test_helper'

class AdminTest < ActionController::IntegrationTest

  test "could see projects" do
    project = Factory(:project)
    login_as(project.user)
    assert page.has_content?(project.title)
  end
  
  test "could see clients" do
    client = Factory(:client)
    login_as(client.user)
    visit url_for([client.user, :clients])
    assert page.has_content?(client.name)
  end
  
  test "could see people" do
    person = Factory(:person)
    login_as(person.user)
    visit url_for([person.user, :people])
    assert page.has_content?(person.name)
  end
  
  test "add new pages" do
    project = Factory(:project)
    login_as(project.user)
    visit new_user_project_path(project.user)
    assert page.has_content?("Add new Project")
    visit new_user_client_path(project.user)
    assert page.has_content?("Add new Client")
    visit new_user_person_path(project.user)
    assert page.has_content?("Add new Employee")
  end
  
  test "can open calendar" do
    user = Factory(:user)
    login_as(user)
    visit url_for([user, :calendars])
    assert page.has_content?(Time.now.strftime("%B"))
    click_link "Next Month"
    assert page.has_content?((Time.now + 1.month).strftime("%B"))
    click_link "Previous Month"
    assert page.has_content?((Time.now).strftime("%B"))
  end
  
  test "earnings page is open" do
    user = Factory(:user)
    project = Factory(:project, :user => user)
    project2 = Factory(:project, :user => user)
    project3 = Factory(:project, :user => user)        
    login_as(user)
    click_link "Earnings"
    assert page.has_content?("Monthly Average")
  end

end
