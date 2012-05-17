class Invitations < ActionMailer::Base
  default_url_options[:host] = 'jeanapp.com'
  default :from => 'Jean <jean@jeanapp.com>'  
  
  def sending_invitation(invitation)
    @inv = invitation
    mail(:to => invitation.email, :subject => "Invitation to Jean")
  end

  def employee_added_invitation(user)
    @user = user
    @user.invitation_uuid = (0...8).map{65.+(rand(25)).chr}.join
    @user.save(:validate => false)
    mail(:to => @user.email, :subject => "Invitation to Jean App")
  end

end
