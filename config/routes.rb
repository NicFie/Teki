Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :games, only[:new, :create, :show]

  resources :users do
    resources :friendships, only[:new, :create, :destroy]
  end

  resources :rounds, only[:new, :create] do
    resources :challenges, only[:show]
  end
end
