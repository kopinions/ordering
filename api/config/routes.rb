Rails.application.routes.draw do
  resources :products

  resources :users do
    resources :orders do
      member do
        get 'payment'
      end
    end
  end
end
