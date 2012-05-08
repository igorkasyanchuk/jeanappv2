class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      if current_user.owner?
        redirect_back_or_default(user_projects_path(@user))
      else
        redirect_to [@user, :other_projects]
      end
    else
      render :action => :new
    end
  end
  
  def index
  end

end
