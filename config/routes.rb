Rails.application.routes.draw do
  resources :events, only: [:index, :show, :create]
  resources :register, only: [:create]
  resources :event_items, only: [:show, :create]
  patch '/event_items', to: 'event_items#update'
  delete '/event_items', to: 'event_items#destroy'
  resources :sellers, only: [:create]
  post  '/signin',  to: 'sessions#new'
end
