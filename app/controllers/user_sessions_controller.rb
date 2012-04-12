class UserSessionsController < ApplicationController
  before_filter :redirect_if_user, :only => [:new]
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:destroy, :logout_user_session]
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session], params[:user_session][:remember_me])
    if @user_session.save
      flash[:notice] = "Login successful!"
      if @user_session.user.owner?
        redirect_back_or_default user_projects_path(@user_session.user)
      else
        redirect_back_or_default [@user_session.user, :other_projects]
      end
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
  
  def logout
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
  
  private
    def redirect_if_user
      redirect_to user_projects_path(current_user) if current_user
    end
  
end