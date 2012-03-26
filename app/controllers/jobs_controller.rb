class JobsController < SecureController
  #belongs_to :project
  
  def create
    @project = if request.referer.include? user_other_projects_path(current_user)
      params[:job][:person_id] = current_user.id
      current_user.other_projects
     elsif request.referer.include? user_projects_path(current_user)
      current_user.projects  
    end.find params[:job][:project_id]
    params[:job].delete(:project_id)
    @job = @project.jobs.create params[:job]
    create!  do |format|
      format.js {}
    end
  end
  
  def destroy
     destroy!  do |format|
      format.js {}
    end
  end

  def next_state
    @project = current_user.projects.find params[:project_id]
    @job = @project.jobs.find params[:id]
    @job.next_state
  end

  def prev_state
    @project = current_user.projects.find params[:project_id]
    @job = @project.jobs.find params[:id]
    @job.prev_state
  end

  def approves
    @project = current_user.projects.find params[:project_id]
    @job = @project.jobs.find params[:id]
    if params[:status] == '1'
      @job.approve
    elsif params[:status] == '-1'
      @job.unupprove
    elsif params[:status] == '0'
      @job.pay
    end
    render :create, :format => :js

  end  
  
end
