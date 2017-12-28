Rails.application.routes.draw do
  # sellers
  resources :sellers, only: [:create]
  get '/sellers', to: 'sellers#show'
  patch '/sellers', to: 'sellers#update'
  delete '/sellers', to: 'sellers#destroy'
  # events
  resources :events, only: [:index, :show, :create]
  patch '/events', to: 'events#update'
  delete '/events', to: 'events#destroy'
  # event items
  resources :event_items, only: [:show, :create]
  patch '/event_items', to: 'event_items#update'
  delete '/event_items', to: 'event_items#destroy'
  # register
  resources :register, only: [:create]
  # sessions
  post  '/signin',  to: 'sessions#new'
  get '/auth/:provider/setup', to: 'sessions#setup'
  get '/auth/:provider/callback', to: 'sessions#callback'
  # sales log
  get '/sales_logs/:event_id', to: 'sales_logs#show'
end
