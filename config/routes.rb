Rails.application.routes.draw do
  resources :items, only: [:show, :new, :create, :destroy]
  resources :events, only: [:show, :create]
  resources :register, only: [:create]
end
