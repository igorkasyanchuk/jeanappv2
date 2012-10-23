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

    params[:sort] ||= current_user.sort_field
    params[:direction] ||= current_user.sort_direction

    current_user.update_attribute(:sort_field, params[:sort])
    current_user.update_attribute(:sort_direction, params[:direction])

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

  def toggle_employee
    @project = resource
    @person = Person.find(params[:person_id])
    if @project.project_staffs.by_person(@person.id).any?
      @project.project_staffs.where(:person_id => @person.id).delete_all
    else
      ProjectStaff.create(:person_id => @person.id, :project_id => @project.id, :description => '', :hourly_rate => @person.hourly_rate)
    end
    render :nothing => true
  end
   
  private
  
    def sort_column
      Project.column_names.include?(params[:sort]) ? params[:sort] : (params[:sort] =~ /hourly_rate|profit|client/ ? params[:sort] : "title")
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
    
end