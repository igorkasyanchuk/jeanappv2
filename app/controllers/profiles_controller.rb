class ProfilesController < ApplicationController
  layout 'admin'
  
  before_filter :require_user

  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Profile successfully updated.'
      redirect_to edit_profile_path(current_user)
    else
      render :action => :edit
    end
  end
  
end
