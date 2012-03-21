class InvitationsController < SecureController

  def confirm
    @Invitation = Invitation.find_by_key(params[:key])
    @Invitation.confirm_inv
  end
  

end
