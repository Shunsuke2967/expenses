Rails.application.routes.draw do
  root to: 'months#index'
  get '/add/:id', to: 'templates#add'
  post '/monthcurrent/:id', to: 'months#monthcurrent'
  post '/add', to: 'templates#createadd'
  resources :users
  resources :months
  resources :sessions, only: [:index,:create]
  resources :days, only: [:new,:create,:destroy,:edit,:update]
  resources :templates, only: [:new,:edit,:update,:destroy,:create]
  resources :budgets, only: [:new,:edit,:create,:update,:show]


  # get '*path', to: 'application#render_404'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
