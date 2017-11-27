Rails.application.routes.draw do
  resources :items, only: [:show, :new, :create]
  resources :events, only: [:show, :create]
  resources :register, only: [:create]

  post '/items/delete', to: 'items#destroy'
end
