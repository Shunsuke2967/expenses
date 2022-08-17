Rails.application.routes.draw do
  root to: 'months#index'

  #user
  resources :users do
    collection do
      get :terms
      get :expansions
      post :update_expansion
      post :delete_expansion
    end
  end

  #session
  resources :sessions, only: [:index,:create] do
    collection do
      get :demo
    end
  end

  # day
  get '/days', to: 'days#new'
  resources :days, only: [:new,:create,:destroy,:edit,:update] 

  # template
  get '/templates', to: 'templates#new'
  resources :templates do
    collection do
      post :add
      get :day_select
      post :days_create
    end

    member do
      get :add
    end
  end

  #budget
  resources :budgets, only: [:new,:edit,:create,:update,:show]

  # month
  resources :months do
    collection do
     post 'search'
     get 'expenses_list'
     get "current_salary"
    end

    member do
      post :month_current
    end
  end

  #get '*path', to: 'application#render_404'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
