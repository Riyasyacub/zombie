Rails.application.routes.draw do
  apipie
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  scope :api, defaults: { format: :json } do
    resources :users
    resources :trades, only: [:create]
  end
end
