Poesearch::Application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }

  root to: "searches#new"

  resources :users, except: [:index] do
    member do
      post :generate_token
      get :link_character
      post :validate_account
    end
    resource :account
  end

  resources :searches, except: [:edit] do
    collection do
      get :favorite, as: :favorite
    end
  end

  resources :searches, except: [:edit]
  [:weapons, :armours, :misc].each do |type|
      resources :"#{type.to_s.singularize}_searches", except: [:edit]
  end

  resources :similar_searches

  resources :items, only: [:show, :destroy] do
    member do
      post    :add_to_cart
      delete  :remove_from_cart
      post    :verify
    end
  end

  resource :shopping_cart

  resources :authentications, only: [:create, :destroy]

  resources :messages

  resources :players do
    member do
      put :mark_online
      put :mark_offline
    end
  end

  resources :accounts

  resources :posts

  namespace :admin do
    root to: "admin#index"
    resources :searches
    resources :broadcasts
    resources :messages, only: [:index, :show]
    resources :posts
    resources :scrawls
  end

  resources :exiles do
    member do
      put :vote_up
    end
  end

  get "/feedback",  to: "feedback#index", as: :feedback
  get "/about/item_prices", to: "about#item_prices", as: :item_prices
  get "/about/search_by_price", to: "about#search_by_price", as: :search_by_price
  get "/about/faq", to: "about#faq", as: :faq

  match '/auth/:provider/callback' => 'authentications#create', via: :get
end
