Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               omniauth_callbacks: 'users/omniauth_callbacks'
             }
  devise_scope :user do
    get 'users/login', to: 'users/sessions#new', as: :new_user_session
    get 'users/logout', to: 'users/sessions#destroy', as: :destroy_user_session
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # root 'application#index'
  # Defines the root path route ("/")
  # root "articles#index"

  resources :users do
    collection do
      get 'search'
    end
  end

  resources :activities do
    member do
      get :delete
      post :verify_attendance
      get :signups
      post :signup
    end
  end

  # config/routes.rb
  resources :activity_types do
    member do
      get :delete
    end
  end

  resources :articles do
    member do
      get :delete
    end
  
    collection do
      get :recent_articles
    end
  end
  

  resources :article_categories do
    member do
      get :delete
    end
  end
  resources :article_modules do
    member do
      get :delete
      post :increase_priority
      post :decrease_priority
    end
  end

  get 'advanced_settings/index'
  get 'help', to: 'general#help'

  root 'welcome#index'
end
