# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  namespace :api do
    namespace :v1 do
      resources :users do
        collection do
          get 'me' => 'users#me'
        end
      end
      post 'validate_token' => 'sessions#validate_token'
      post 'login' => 'sessions#login'
    end
  end
end
