class OtherProjectsController < SecureController
  helper_method :sort_column, :sort_direction
  
  def index
    @projects = current_user.other_projects
  end

end
