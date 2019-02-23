# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      resources :users
      post 'validate_token' => 'sessions#validate_token'
      post 'login' => 'sessions#login'
    end
  end
end
