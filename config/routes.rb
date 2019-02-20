# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: :create
      post 'validate_token' => 'session#validate_token'
      post 'login' => 'session#login'
    end
  end
end
