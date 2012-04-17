class JobsController < SecureController
  #belongs_to :project
  
  def create
    @project = Project.find params[:job][:project_id]
    params[:job].delete(:project_id)

    staff = @project.project_staffs.by_person(params[:job][:person_id]).first
    params[:job][:rate] = staff.hourly_rate

    @job = @project.jobs.create params[:job]

    logger.info @job.errors.full_messages.inspect
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
    render 'change_state'#:create, :format => :js

  end  
  
end
