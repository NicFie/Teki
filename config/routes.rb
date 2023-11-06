Rails.application.routes.draw do
  devise_for :users
  #root to: "pages#home"
  get '/dashboard', to: 'pages#dashboard', as: 'dashboard'
  get '/user-settings', to: 'pages#user_settings', as: 'user_settings'
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
  resources :leagues, only: %i[index new create show]

  resources :users do
    resources :games, only: %i[new create]
    resources :game_rounds, only: %i[index]
    member do
      get :send_game_invitation
      post :send_invitation
      post :accept_invitation
      delete :reject_invitation
    end
  end

  resources :games, only: %i[show edit update] do
    member do
      post :round_won
      post :update_display
      post :user_code
      post :user_ready_next_round
      post :forfeit_round
      post :invite_response
      post :cancel_invite
      post :game_disconnected
      post :game_metadata
    end
    resources :game_rounds, only: %i[new create] do
      resources :challenges, only: %i[show]
    end
  end

  resources :game_rounds, only: %i[update]
end
