Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :challenges, only: %i[new create]

  resources :users do
    resources :friendships, only: %i[new create destroy]
    resources :games, only: %i[new create]
    resources :game_rounds, only: %i[index]
  end

  resources :friendships, only: %i[edit update index show]

  resources :games, only: %i[show edit update] do
    member do
      post :game_test
    end

    resources :game_rounds, only: %i[new create] do
      resources :challenges, only: %i[show]
    end
  end
end
