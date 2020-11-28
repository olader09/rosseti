require 'sidekiq/web'

Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  mount Sidekiq::Web => '/sidekiq'

  post :user_token, to: 'user_token#create'
  resource :user

  resources :applications do
    put :like, to: 'applications#like', on: :collection
    put :dislike, to: 'applications#dislike', on: :collection
  end
  resources :messages
  resources :chats


end
