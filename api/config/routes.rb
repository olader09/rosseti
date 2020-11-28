require 'sidekiq/web'

Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  mount Sidekiq::Web => '/sidekiq'

  post :user_token, to: 'user_token#create'
  resource :user

  resources :applications do
    put 'like/:id', to: 'applications#like', on: :member
  end
  resources :messages
  resources :chats


end
