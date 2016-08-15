Rails.application.routes.draw do
  root to: 'main#main'
  get '/main', to: 'main#main'

  namespace :api do
    namespace :v1 do
      get '/hello', to: 'hello#hello'

      resources :users do
        collection do
          post :login
        end
        member do
          get :microposts_count, :following, :followers, :following_count, :followers_count
        end
      end

      resources :microposts
      resources :relationships
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
