class InvitationsController < SecureController

  skip_before_filter :require_user, :check_user_permissions, :only => [:confirm, :user_confirm]

  def confirm
    @invitation = Invitation.find_by_key(params[:key])
    if @invitation.present?
      if @invitation.actual?
        @invitation.confirm
        flash[:notice] = 'Invitation was successfully accepted!'
      else
        @invitation.destroy
        flash[:notice] = 'Invitation is not actual.'
      end
      redirect_to root_url
    else
      flash[:notice] = 'Invitation was expired!'
      redirect_to root_url
    end
  end

  def user_confirm
    @user = User.find_by_invitation_uuid(params[:key])
    if @user.present?
      @user.invitation_uuid = nil
      @user.save(:validate => false)
      UserSession.create(@user)
      redirect_to edit_profile_path(@user)
    else
      flash[:notice] = "Can't find user!"
      redirect_to root_url
    end
  end


  def create
    @invitation = Invitation.new(params[:invitation])
    @person = Person.find_by_email(@invitation.email)
    @project = current_user.projects.find(@invitation.project_id)

    if @person.present? && @project.people.include?(@person)
      flash[:notice] = 'You already have this employee in your project!'
      redirect_to project_employees_path(@project)
    else
      respond_to do |format|
        if @invitation.save
          flash[:notice] = 'Invitation was successfully sent!'
          format.html { redirect_to project_employees_path(@project) }
        else
          flash[:notice] = @invitation.errors.full_messages.first
          format.html { redirect_to project_employees_path(@project) }
        end
      end
    end

  end


end
