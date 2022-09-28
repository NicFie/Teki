Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :games, only: %i[new create show]

  resources :users do
    resources :friendships, only: %i[new create destroy]
  end

  resources :game_rounds, only: %i[new create] do
    resources :challenges, only: %i[show]
  end
end
