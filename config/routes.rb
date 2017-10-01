Rails.application.routes.draw do
  get 'welcome/index'

  # Handle Basic Auth for Admin
  resources :sessions, only: [:index, :new, :create, :destroy]
  get 'portal', to: 'session#index'
  get 'login', to: 'sessions#new'
  delete 'logout', to: 'sessions#destroy'

  resources :artists do
    resources :songs
    resources :albums
  end

  resources :albums do
    resources :songs
  end

  resources :songs

  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
