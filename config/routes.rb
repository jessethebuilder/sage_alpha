# require 'resque/server'
Rails.application.routes.draw do
  resources :mail_image_requests


  resources :comments

  resources :mail_queues do
    member do
      get 'send_emails'
    end
  end



  resources :mail_images, only: [:create, :show]


  # devise_for :clients

  resources :clients do
    member do
      get 'custom_mail_queue'
      post 'unmatch_from'
    end
  end

  # devise_for :users has to be above resources :users
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

  resource :client_keyword_matches, only: [:create]

  root to: "users#unknown"
end
