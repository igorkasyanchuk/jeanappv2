TrackMyTime::Application.routes.draw do
  resource :user_session do 
    get 'logout'
  end
    
  resources :password_resets
  root :controller => 'user_sessions', :action => 'new'
  
  resources :users do
    resources :earnings, :only => [:index]
    resources :time_reports, :only => [:index]
    resources :people
    resources :user_moneys
    resources :calendars, :only => [:index]
    resources :clients do
      member do
        get :projects
      end
    end
    resources :other_projects, :controller => 'other_projects'
    resources :projects do
      member do
        get :toggle_project
      end
      resources :expenses
      resources :invoices
      resources :project_staffs
      resources :own_hours
      resources :invitations
    end
    resources :notes
  end

  resources :projects, :only => :index do
    resources :employees, :only => :index
  end


  resources :jobs do
    member do
      get :approves
      put :next_state
      put :prev_state
    end
  end

  resources :profiles, :only => [:edit, :update]
  match "/invitations/confirm/:key", :to => "invitations#confirm", :as => "confirm_invitation"
  
end
