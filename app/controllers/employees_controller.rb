class EmployeesController < SecureController
  def index
    @project = current_user.projects.find params[:project_id]
    #@employees = current_user.projects.find(params[:project_id]).people
  end
end
