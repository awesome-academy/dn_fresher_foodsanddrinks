Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :users, only: %i(show)
    resource :carts, except: %i(new edit)
    resources :products, only: %i(show)

    resources :orders, except: %i(index edit destroy)
    resources :order_confirms, only: %i(edit)

    namespace :admin do
      root "dashboard#index"
      resources :orders, only: %i(index update)
    end
  end
end
