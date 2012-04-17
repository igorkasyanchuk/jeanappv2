class OtherProjectsController < SecureController
  helper_method :sort_column, :sort_direction
  
  def index
    @projects = (current_user.other_projects_with_history + current_user.other_projects).uniq
  end

  def show
    @project = current_user.other_projects.find_by_id params[:id]
    @project = current_user.other_projects_with_history.find_by_id params[:id] unless @project
  end

end
