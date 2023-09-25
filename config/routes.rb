Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :forecast, only: :index
      resources :users, only: :create
      resources :sessions, only: :create
    end

    namespace :v1 do
      get 'book-search', to: 'books#search'
    end
  end
end
