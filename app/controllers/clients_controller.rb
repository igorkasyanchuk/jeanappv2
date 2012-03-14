class ClientsController < SecureController
  helper_method :sort_column, :sort_direction, :project_sort_column

  belongs_to :user
  actions :index, :show, :new, :create, :edit, :update, :destroy
  
  def index
    _clients = current_user.clients
    if params[:sort] == 'local_time'
      @clients = _clients.all.sort{|a, b| a.local_time <=> b.local_time}
      @clients.reverse! if params[:direction] == 'desc'
    elsif params[:sort] == 'projects_in_progress'
      @clients = _clients.all.sort{|a, b| a.projects.in_progress.count <=> b.projects.in_progress.count}
      @clients.reverse! if params[:direction] == 'desc'
    elsif params[:sort] == 'projects_total'
      @clients = _clients.all.sort{|a, b| a.projects.count <=> b.projects.count}
      @clients.reverse! if params[:direction] == 'desc'
    elsif params[:sort] == 'empoyees_total'
      @clients = _clients.all.sort{|a, b| a.empoyees_count <=> b.empoyees_count }
      @clients.reverse! if params[:direction] == 'desc'
    else
      @clients = _clients.order(sort_column + " " + sort_direction)
    end
  end
  
  def show
    @client = resource
    @projects = @client.projects
  end
  
  def projects
    @client = resource
    _projects = case params['filter']
      when 'closed'
        @client.projects.completed
      when 'in-progress'
        @client.projects.in_progress
      else
        @client.projects
    end
    if params[:sort] == 'hourly_rate'
      @projects = _projects.all.sort{|a, b| a.personal_rate <=> b.personal_rate}
      @projects.reverse! if params[:direction] == 'desc'
    elsif params[:sort] == 'profit'
      @projects = _projects.all.sort{|a, b| a.profit <=> b.profit}
      @projects.reverse! if params[:direction] == 'desc'
    else
      @projects = _projects.order(project_sort_column + " " + sort_direction)
    end
    render :show
  end
  
  private
  
    def sort_column
      Client.column_names.include?(params[:sort]) ? params[:sort] : (params[:sort] =~ /empoyees_total|hours|money|projects_in_progress|projects_closed|projects_total|local_time/ ? params[:sort] : "name")
    end
    
    def project_sort_column
      Project.column_names.include?(params[:sort]) ? params[:sort] : (params[:sort] =~ /hourly_rate|profit/ ? params[:sort] : "title")
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
    
end