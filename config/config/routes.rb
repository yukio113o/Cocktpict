Rails.application.routes.draw do
  devise_for :users,
  controllers: {registrations:'registrations' }
  
    root 'posts#index'
    
    get '/users/:id', to: 'users#show', as: 'user'
    
    resources :posts, only: %i(index new create show destroy) do
      resources :photos, only: %i(create)
      resources :likes, only: %i(create destroy)
      resources :comments, only: %i(create destroy)
    end
    
    resources :users do
      resources :relationships, only: [:create, :destroy]
      get '/users/:id/followings', to: 'relationships#followings', as: 'followings'
      get '/users/:id/followers', to: 'relationships#followers', as: 'followers'
    end
end