# require 'resque/server'
Rails.application.routes.draw do
  # mount Resque::Server.new, at: '/resque'

  resources :comments

  resources :mail_queues do
    member do
      get 'send_emails'
    end
  end

  resources :clients

  resources :mail_images, only: [:create]


  devise_for :users

  resources :users, only: [:index, :destroy, :create] do
    member do
      get 'promote'
      get 'demote'
    end

    collection do
      get 'unknown'
    end
  end

  root to: "users#unknown"
end
