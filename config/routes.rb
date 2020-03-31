Rails.application.routes.draw do
  resources :locations
  resources :articles
  resources :businesses do
    member do
      post 'add_location'
      post 'add_article'
    end
  end
  devise_for :users
  root 'pages#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
