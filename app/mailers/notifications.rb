class Notifications < ActionMailer::Base
  default_url_options[:host] = 'jeanapp.com'
  default :from => 'Jean <jean@jeanapp.com>'

  def forgot_password(user)
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
    mail :to => user.email
  end

end
