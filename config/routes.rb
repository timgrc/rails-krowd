Rails.application.routes.draw do
  devise_for :users

  root to: 'pages#home'

  post "yammer", to: "users/omniauth_callbacks#yammer"
  get "yammer/callback", to: "users/omniauth_callbacks#callback"

  resources :groups, only: [:index, :show, :new, :create, :delete] do
    resources :incentive_templates
    post '/incentive_templates/push_templates', to: 'incentive_templates#push_templates', as: 'push_templates'
    resources :push_posts, only: [:create]
  end

end
