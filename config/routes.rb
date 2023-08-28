Rails.application.routes.draw do
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "static_pages/home"
  get "static_pages/help"
  get "static_pages/contact"

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :users, only: %i(show edit update index destroy)

  resources :account_activations, only: %i(edit)

  resources :password_resets, only: %i(new create edit update)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
