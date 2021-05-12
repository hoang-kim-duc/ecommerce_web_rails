Rails.application.routes.draw do
  root "static_page#home"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
end
