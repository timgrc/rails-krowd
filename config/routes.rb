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
  end

end
