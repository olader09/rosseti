Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  post :user_token, to: 'user_token#create'
  resource :user

  post :admin_token, to: 'admin_token#create'
  resource :admin

  resources :applications do
    put :like, to: 'applications#like', on: :collection
    put :dislike, to: 'applications#dislike', on: :collection
    get :similar, to: 'applications#similar', on: :member
    get :check_uniq, on: :collection
  end
  resources :messages
  resources :chats
end
