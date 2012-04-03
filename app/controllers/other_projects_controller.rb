class OtherProjectsController < SecureController
  helper_method :sort_column, :sort_direction
  
  def index
    @projects = current_user.other_projects
  end

  def show
    @project = current_user.other_projects.find params[:id]
  end

end
