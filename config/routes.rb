Rails.application.routes.draw do
  resources :quizzes
  devise_for :users, controllers: { registrations: "registrations" }

  resources :messages
  root to: 'events#index'

  resources :posts do
    resources :comments
  end

  namespace :api, defaults: { format: 'json' } do
    resources :users do
      collection do
        post 'authenticate'
        post 'delete_all'
      end
    end
    resources :quizzes do
      collection do
        get 'computer'
        post 'validate'
      end
    end
    get 'hit-count', action: :remote_ip, controller: 'common'
    get 'ipaddress/list', action: :ipaddress_lists, controller: 'common'
  end

  resources :articles

  get 'search', to: 'search#search'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ActionCable.server => '/cable'
end
