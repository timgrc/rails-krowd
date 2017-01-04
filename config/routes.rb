Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: 'groups#index'
  end

  root to: 'pages#home'
  get 'test', to: 'pages#test'

  post "yammer", to: "users/omniauth_callbacks#yammer"
  get "yammer/callback", to: "users/omniauth_callbacks#callback"

  post 'bot', to: 'push_messages#bot_answer'
  # get 'bot', to: 'push_messages#bot_answer'

  resources :groups, only: [:index, :show, :new, :create, :destroys] do
    resources :incentive_templates
    resources :push_messages, only: [:create]
  end

  resources :memberships, only: [:destroy]


  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
