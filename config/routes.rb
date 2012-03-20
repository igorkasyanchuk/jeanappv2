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
    end
    resources :notes
  end


  resources :jobs

  resources :profiles, :only => [:edit, :update]

end
