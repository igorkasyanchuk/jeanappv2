class Invitations < ActionMailer::Base
  default_url_options[:host] = 'jeanapp.com'
  default :from => 'Jean <jean@jeanapp.com>'  
  
  def sending_invitation(invitation)
    @inv = invitation
    mail(:to => invitation.email, :subject => "Invitation to Jean")
  end

end
