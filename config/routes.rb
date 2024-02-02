# frozen_string_literal: true

Rails.application.routes.draw do
  resources :shopping_lists
  resources :items
  resources :inventories
  resources :nonplayers
  resources :players
  resources :characters
  

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root 'gameplays#index'
  get '/town' => 'gameplays#town', as: 'town'
  get '/characters/:id/profile' => 'characters#profile', as: 'character_profile'
  get '/characters/:id/inventory' => 'characters#inventory', as: 'character_inventory'
  get '/trade/:id/' => 'trade#trade', as: 'trade'
  get '/underconstruction' => 'gameplays#underconstruction', as: 'underconstruction'
  get '/shopping+list' => 'shopping_lists#player_shopping_list', as: 'player_shopping_list'

  post '/launch/:id', to: 'shopping_lists#launch', as: 'launch'
  post '/trade/:id/trade_accept/:character_id' => 'trade#trade_accept', as: 'trade_accept'
end
