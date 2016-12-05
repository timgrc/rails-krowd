Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :groups, only: [:show, :new, :create, :delete] do
    resources :incentive_templates
    post '/incentive_templates/push_templates', to: 'incentive_templates#push_templates', as: 'push_templates'
  end

end
