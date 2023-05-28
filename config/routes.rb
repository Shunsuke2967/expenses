Rails.application.routes.draw do
  root to: 'expenses#index'

  #user
  resources :users do
    collection do
      get :terms
      get :expansions
      get :news
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
  resources :budgets

  # expense
  resources :expenses do
    collection do
      post 'search'
      get 'list'
    end

    member do
      post :change    end
  end

  #get '*path', to: 'application#render_404'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
