Rails.application.routes.draw do

  get 'items/:item_id', to: 'items#show'
  get 'events/:event_id', to: 'events#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
