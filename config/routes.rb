Rails.application.routes.draw do
  resources :items, only: [:show, :new, :create]
  resources :events, only: [:show, :create]
  resources :register, only: [:create]
  resources :sellers, only: [:create]
  post  '/signin',  to: 'sessions#new'
end
