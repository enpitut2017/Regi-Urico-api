Rails.application.routes.draw do
  resources :events, only: [:index, :show, :create]
  patch '/events', to: 'events#update'
  delete '/events', to: 'events#destroy'
  resources :register, only: [:create]
  resources :event_items, only: [:show, :create]
  patch '/event_items', to: 'event_items#update'
  delete '/event_items', to: 'event_items#destroy'
  resources :sellers, only: [:create]
  patch '/sellers', to: 'sellers#update'
  delete '/sellers', to: 'sellers#destroy'
  post  '/signin',  to: 'sessions#new'
  get '/auth/:provider/callback', to: 'sessions#callback'
end
