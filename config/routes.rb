Rails.application.routes.draw do
  root to: 'months#index'

  resources :users
  resources :sessions, only: [:index,:create]
  resources :days, only: [:new,:create,:destroy,:edit,:update]
  resources :templates, only: [:new,:edit,:update,:destroy,:create]
  resources :budgets, only: [:new,:edit,:create,:update,:show]

  # month
  resources :months do
    collection do
     get 'search'
    end
  end
  post '/month_current/:id', to: 'months#month_current'

  # template
  post '/add', to: 'templates#createadd'
  get '/add/:id', to: 'templates#add'
  get '/templates', to: 'templates#new'
  get '/templates/:id', to: 'templates#edit'

  # day
  get '/days/:id', to: 'days#edit'
  get '/das', to: 'days#new'

  #get '*path', to: 'application#render_404'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
