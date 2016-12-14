Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: 'groups#index'
  end

  root to: 'pages#home'
  get "styleguide", to: "pages#styleguide"

  post "yammer", to: "users/omniauth_callbacks#yammer"
  get "yammer/callback", to: "users/omniauth_callbacks#callback"

  resources :groups, only: [:index, :show, :new, :create, :delete] do
    resources :incentive_templates
    resources :push_messages, only: [:create]
    resources :memberships, only: [:delete]
  end

  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
