Rails.application.routes.draw do
  resources :products

  resources :users do
    resources :orders
  end
end
