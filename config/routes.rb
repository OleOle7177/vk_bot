Rails.application.routes.draw do
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  root 'fakes#index'

  resources :fakes do
    collection do
      get 'notify'
    end
  end

  resources :sessions

end
