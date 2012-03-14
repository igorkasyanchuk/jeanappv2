require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  
  test "correctly update budget" do
    @project = Factory(:project, :budget => 5_000)
    @invoice = Factory(:invoice, :project => @project, :hours_count => 10, :hourly_rate => 15.0)
    @project.reload
    assert @project.invoices.count == 1
    assert_equal @project.project_invoices, 10 * 15.0
  end
  
  test "correctly update budget 2" do
    @project = Factory(:project, :budget => 5_000)
    @project.invoices.create(:description => 'description', :hourly_rate => 15.0, :hours_count => 10)
    @project.reload
    assert_equal @project.cached_budget, 5000 + 10 * 15.0
  end
  
  
end
