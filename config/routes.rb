Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: 'groups#index'
  end

  root to: 'pages#home'

  post "yammer", to: "users/omniauth_callbacks#yammer"
  get "yammer/callback", to: "users/omniauth_callbacks#callback"

  post 'bot', to: 'push_messages#bot_answer'
  # get 'bot', to: 'push_messages#bot_answer'

  resources :groups, only: [:index, :show, :new, :create, :destroys] do
    resources :incentive_templates
    get 'change_incentive_template', to: 'incentive_templates#change'
    resources :push_messages, only: [:create]
  end

  resources :memberships, only: [:destroy]

  get 'demo', to: 'groups#demo'

  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
