# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
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
      resources :tickets, :ticket_activity_logs
      resources :dashboard, only: :index

      get 'my_projects' => 'users_projects#my_projects'
      post 'validate_token' => 'sessions#validate_token'
      post 'login' => 'sessions#login'
    end
  end
end
