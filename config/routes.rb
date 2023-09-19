Rails.application.routes.draw do
  root 'pages#home'
  get 'pages/home'
  resources :users, only: [:index] do
    member do
      get :ban
      put 'reactivate', to: 'users/registrations#reactivate'
    end
  end
  resources :posts
  resources :admin, only: %i[index create update]
  delete '/sign_out', to: 'sessions#destroy', as: :sign_out
  post '/generate_password', to: 'users#generate_password', as: :generate_password
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  get '/auth/google_oauth2/callback', to: 'sessions#create'
  get '/auth/:provider/callback', to: 'sessions#create'

  authenticate :user, lambda { |u| u.admin? } do
    require 'resque/server'
    mount Resque::Server.new, at: '/resque'
  end
  # get 'admin/index'
  # post '/admin/users', to: 'admin#create', as: 'admin_user'
  # patch '/adminusers/:id', to: 'admin#update', as: 'admin_user'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
end
