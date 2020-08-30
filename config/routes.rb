Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :users, only: %i(show)
    resource :carts, except: %i(new edit)
    resources :products, only: %i(show)

    resources :orders, only: %i(show new create)
  end
end
