Rails.application.routes.draw do
  resources :items, only: [:show, :new, :create]
  resources :event, only: [:show]
  resources :register, only: [:create]
end
