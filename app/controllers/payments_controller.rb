class PaymentsController < SecureController

  def index
    @projects = current_user.projects
  end

end