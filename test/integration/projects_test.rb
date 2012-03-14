require 'test_helper'

class ProjectsTest < ActionController::IntegrationTest

  test "test projects" do
    user = Factory(:user)
    login_as(user)
    assert page.has_content?('Projects')
  end
  
  test "could open project page" do
    user = Factory(:user)
    login_as(user)
    project = Factory(:project, :user => user)
    project_dummy = Factory(:project)
    click_link "Projects"
    assert page.has_content?(project.title)
    assert_false page.has_content?(project_dummy.title)
    
    visit url_for([user, project])
    assert page.has_content?(project.title)
    assert page.has_content?("Money")

    visit url_for([user, :projects])

    assert_raises(ActiveRecord::RecordNotFound) do
      visit url_for([user, project_dummy])
    end

    assert_false page.has_content?(project_dummy.title)
    assert_false page.has_content?("Money")
  end
  
  test "project length correct" do
    user = Factory(:user)
    login_as(user)
    project = Factory(:project, :user => user, :started_on => "2010-10-10", :completed_on => "2010-10-14")
    visit url_for([user, project])
    assert page.has_content?("4 days")
  end
  
  test "could create new project" do
    user = Factory(:user)
    login_as(user)
    click_link "Project"
    click_link "Add Project"
    fill_in "project_title", :with =>"project_title"
    fill_in "project_budget", :with => "305.78"
    click_button "Create"
    assert page.has_content?("Money")
    assert page.has_content?("0 days")
  end
  
  test "open complex project" do
    user = Factory(:user)
    login_as(user)
    project = Factory(:project, :user => user)
    person = Factory(:person, :user => user, :hourly_rate => 13.3)
    visit url_for([user, project])
    assert page.has_content?(project.title)
    project.project_staffs.create(:person_id => person.id, :hours_count => 10, :description => 10)
    visit url_for([user, project])
    assert page.has_content?("133")
    project.own_hours.create(:hours_count => 5, :description => "cool_description")
    visit url_for([user, project])
    assert page.has_content?("cool_description")
    project.expenses.create(:amount => 555, :description => "exp_description")
    visit url_for([user, project])
    assert page.has_content?("exp_description")
    project.invoices.create(:hours_count => 2, :hourly_rate => 11, :description => "invoices_description")
    visit url_for([user, project])
    assert page.has_content?("invoices_description")
    assert page.has_content?("22")
  end

end
