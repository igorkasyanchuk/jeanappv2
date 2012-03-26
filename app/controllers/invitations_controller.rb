class InvitationsController < SecureController

  def confirm
    @Invitation = Invitation.find_by_key(params[:key])
    @Invitation.confirm_inv
    redirect_to root_url
    #if @invitation.expires_at >= Time.now
      #@Invitation.confirm_inv
      #flash[:notice] = 'Invitation was successfully accepted!'
      #redirect_to root_url
    #else
      #flash[:notice] = 'Invitation was expired!'
      #redirect_to root_url
    #end
    
  end

  def create
    @invitation = Invitation.new(params[:invitation])

    if current_user.people.map{|p| p.email}.include?(@invitation.email)
      flash[:notice] = 'You already have this user in you employees list!'
      redirect_to user_project_path(current_user, @invitation.project_id)
    else    
      respond_to do |format|        
        if @invitation.save
          flash.now[:notice] = 'Invitation was successfully sent!'
          format.html { redirect_to user_project_path(current_user, @invitation.project_id) }
        else
          flash[:notice] = 'You must enter email address'
          format.html { redirect_to user_project_path(current_user, @invitation.project_id) }
        end
      end
    end

  end
  

end
