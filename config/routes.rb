Rails.application.routes.draw do
  root 'items#index'
  resources :items
  resources :merchants
  resources :users, only: [:index, :create]

  get '/profile', to: 'users#show'
  get '/profile/orders', to: 'orders#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/dashboard', to: 'users#show'
  get '/register', to: 'users#new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
