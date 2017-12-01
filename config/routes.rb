Rails.application.routes.draw do
  resources :items, only: [:show, :new, :create]
  resources :events, only: [:index, :show, :create]
  resources :register, only: [:create]
  delete '/event_items', to: 'event_items#destroy'
  resources :sellers, only: [:create]
  post  '/signin',  to: 'sessions#new'
end
