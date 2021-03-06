class ProjectsController < SecureController
  helper_method :sort_column, :sort_direction

  belongs_to :user
  actions :index, :show, :new, :create, :edit, :update, :destroy
  
  def index
    _projects = case params['filter'] || current_user.last_filter
      when 'closed'
        current_user.update_attribute(:last_filter, "closed")
        current_user.projects.completed
      when 'in-progress'
        current_user.update_attribute(:last_filter, "in-progress")
        current_user.projects.in_progress
      else
        current_user.update_attribute(:last_filter, nil)
        current_user.projects
    end
    if params[:sort] == 'hourly_rate'
      @projects = _projects.all.sort{|a, b| a.personal_rate <=> b.personal_rate}
      @projects.reverse! if params[:direction] == 'desc'
    elsif params[:sort] == 'profit'
      @projects = _projects.all.sort{|a, b| a.profit <=> b.profit}
      @projects.reverse! if params[:direction] == 'desc'
    elsif params[:sort] == 'client'
      @projects = _projects.all.sort{|a, b| (a.client.try(:name) || 'zzz') <=> (b.client.try(:name) || 'zzz')} # hack 'zzz' because it should be after Z*** projects
      @projects.reverse! if params[:direction] == 'desc'
    else
      @projects = _projects.order(sort_column + " " + sort_direction)
    end
  end
  
  def toggle_project
    @project = resource
    @project.toggle_turned!
    if params[:client_page].present?
      redirect_to projects_user_client_path(current_user, @project.client, :filter => params[:filter])
    else
      redirect_to user_projects_path(current_user, :filter => params[:filter])
    end
  end
   
  private
  
    def sort_column
      Project.column_names.include?(params[:sort]) ? params[:sort] : (params[:sort] =~ /hourly_rate|profit|client/ ? params[:sort] : "title")
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
    
end