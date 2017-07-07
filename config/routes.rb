# require 'resque/server'
Rails.application.routes.draw do
  # mount Resque::Server.new, at: '/resque'

  resources :comments

  resources :mail_queues do
    member do
      get 'send_emails'
    end
  end

  resources :clients do
    member do
      get 'custom_mail_queue'
    end
  end


  resources :mail_images, only: [:create, :show]

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
