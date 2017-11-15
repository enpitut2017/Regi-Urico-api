Rails.application.routes.draw do

  resources :items, only: [:show, :new]
  get 'events/:id', to: 'events#show'
  post 'register/', to: 'register#create'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
