Rails.application.routes.draw do
  root "static_pages#home"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  post "/add_to_cart", to: "carts#add_to_cart"
  scope "/checkout" do
    get "/cart", to: "carts#show"
    get "/shipping", to: "delivery_addresses#show"
  end
  resources :products
  resources :delivery_addresses, only: :create
end
