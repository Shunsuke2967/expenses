Rails.application.routes.draw do
  root to: 'expenses#index'

  # ユーザー
  resources :users do
    collection do
      get :terms
      get :expansions
      get :news
      post :update_expansion
      post :delete_expansion
    end
  end

  # セッション
  resources :sessions, only: [:index,:create] do
    collection do
      get :demo
    end
  end

  # 収支
  get '/days', to: 'days#new'
  resources :days, only: [:new,:create,:destroy,:edit,:update] 

  # テンプレート
  resources :templates do
    collection do
      get :day_select
      post :days_create
    end
  end

  # 予算
  resources :budgets, except: [:show, :destroy]

  # 家計簿
  resources :expenses do
    collection do
      post :search
      get :list
      get :edit_salary
      patch :update_salary
      get :salary_list
      patch :update_salary
    end
    member do
      post :change
    end
  end

  # グラフ
  resources :charts, only: [:index]

  # 一括入力
  resources :imports, only: [:index]

  # 推移
  resources :transitions, only: [:index]
end
