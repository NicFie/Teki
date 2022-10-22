Rails.application.routes.draw do
  devise_for :users
  #root to: "pages#home"
  get '/dashboard', to: 'pages#dashboard', as: 'dashboard'
  get '/waiting_room', to: 'games#waiting_room', as: 'waiting'
  # get '/user_code', to: 'games#user_code', as: 'user_code'

  devise_scope :user do
    authenticated :user do
      get '/', to: 'pages#dashboard', as: 'authenticated_root'
    end
    unauthenticated do
      get '/', to: 'pages#home', as: 'unauthenticated_root'
    end
  end

  resources :challenges, only: %i[new create]

  resources :users do
    resources :friendships, only: %i[new create destroy]
    resources :games, only: %i[new create]
    resources :game_rounds, only: %i[index]
  end

  resources :friendships, only: %i[edit update index show destroy]

  resources :games, only: %i[show edit update] do
    member do
      post :game_test
      post :update_display
      post :user_code
    end
    resources :game_rounds, only: %i[new create] do
      resources :challenges, only: %i[show]
    end
  end

end
