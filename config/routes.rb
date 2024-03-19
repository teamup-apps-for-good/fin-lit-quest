# frozen_string_literal: true

Rails.application.routes.draw do
  get 'tutorials/show'
  resources :expenses
  resources :sessions
  resources :preferences
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
  root 'gameplays#index'
  get '/town' => 'gameplays#town', as: 'town'
  get '/underconstruction' => 'gameplays#underconstruction', as: 'underconstruction'

  get '/characters/:id/profile' => 'characters#profile', as: 'character_profile'
  get '/characters/:id/inventory' => 'characters#inventory', as: 'character_inventory'

  get '/shopping+list' => 'shopping_lists#player_shopping_list', as: 'player_shopping_list'
  post '/launch/:id', to: 'shopping_lists#launch', as: 'launch'

  get '/trade/:id/' => 'counter_offer#show', as: 'trade'
  post '/trade/:id/trade_accept/' => 'counter_offer#create', as: 'trade_accept'

  get '/counter_offer/:id', to: 'counter_offer#show', as: 'counter_offer'
  post '/counter_offer/create', to: 'counter_offer#create', as: 'create_counter_offer'

  post 'advance_day', to: 'characters#advance_day', as: 'advance_day'
  post 'launch_to_new_era', to: 'characters#launch_to_new_era', as: 'launch_to_new_era'

  get '/game_over', to: 'gameplays#game_over', as: 'game_over'
  post '/restart_game', to: 'gameplays#restart', as: 'restart_game'

  get '/welcome', to: 'sessions#login', as: 'welcome'
  get '/test_login', to: 'sessions#logged_in', as: 'test_login'
  get '/logout', to: 'sessions#logout', as: 'logout'
  get '/auth/google_oauth2/callback', to: 'sessions#omniauth'

  get '/tutorial/:page', to: 'tutorials#show', as: 'tutorial'

end
