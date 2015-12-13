require 'sidekiq/web'

Rails.application.routes.draw do
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  root 'fakes#index'

  resources :fakes do
    collection do
      get 'notify'
      get 'set_new_friends_notified'
    end
  end

  resources :sessions
  mount Sidekiq::Web, at: '/sidekiq'

end
