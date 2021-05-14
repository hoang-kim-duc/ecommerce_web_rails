Rails.application.routes.draw do
  root "static_pages#home"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  post "/add_to_cart", to: "carts#add_to_cart"
  get "/cart", to: "carts#show"
  resources :products
end
