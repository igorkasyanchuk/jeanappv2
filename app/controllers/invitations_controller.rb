class InvitationsController < SecureController

  skip_before_filter :require_user, :check_user_permissions, :only => :confirm

  def confirm
    @invitation = Invitation.find_by_key(params[:key])
    if @invitation.expires_at >= Time.now
      @invitation.confirm_inv
      flash[:notice] = 'Invitation was successfully accepted!'
      redirect_to root_url
    else
      flash[:notice] = 'Invitation was expired!'
      redirect_to root_url
    end
    
  end

  def create
    @invitation = Invitation.new(params[:invitation])
    @person = current_user.people.find_by_email(@invitation.email)
    @project = current_user.projects.find(@invitation.project_id)
    if @person.present? && @project.people.include?(@person)
      flash[:notice] = 'You already have this employee in your project!'
      redirect_to user_project_path(current_user, @invitation.project_id)
    elsif @person.present?      
      ProjectStaff.create(:person_id => @person.id, :project_id => @invitation.project_id, :description => '')
      flash[:notice] = 'You successfully add employee to your project!'
      redirect_to user_project_path(current_user, @invitation.project_id)
    else
      respond_to do |format|        
        if @invitation.save
          flash[:notice] = 'Invitation was successfully sent!'
          format.html { redirect_to user_project_path(current_user, @invitation.project_id) }
        else
          flash[:notice] = @invitation.errors.full_messages.first
          format.html { redirect_to user_project_path(current_user, @invitation.project_id) }
        end
      end
    end

  end
  

end
