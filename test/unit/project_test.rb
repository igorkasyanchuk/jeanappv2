require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
 
  test "correctly update budget 2" do
    @project = Factory(:project, :budget => 5_000)
    @project.invoices.create(:description => 'description', :hourly_rate => 15.0, :hours_count => 10)
    @project.reload
    assert_equal @project.cached_budget, 5000 + 10 * 15.0
  end

  test "correctly update budget 3" do
    @project = Factory(:project, :budget => 5_000)
    @project.invoices.create(:description => 'description 1', :hourly_rate => 15.0, :hours_count => 10)
    @project.reload
    assert_equal @project.cached_budget, 5000 + 10 * 15.0
    @project.budget = 10_000
    @project.save
    @project.reload
    assert_equal @project.cached_budget, 10_000 + 10 * 15.0
    @project.invoices.create(:description => 'description 2', :hourly_rate => 10, :hours_count => 10)
    @project.reload
    assert_equal @project.cached_budget, 10_000 + 10 * 15.0 + 10 * 10
  end
  
end
