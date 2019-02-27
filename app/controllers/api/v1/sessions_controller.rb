# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      swagger_controller :sessions, 'Sessions'

      swagger_api :login do |_api|
        summary 'API for get auth_token'
        param :form, 'email', :string, :required
        param :form, 'password', :string, :required
        param :form, 'password_confirmation', :string, :required

        response :unauthorized
      end

      def login
        user = User.find_by(email: params[:email].to_s.downcase)

        if user&.valid_password?(params[:password])
          sign_in(:user, user)
          auth_token = JsonWebToken.encode(user_id: user.id)
          render json: {
            auth_token: auth_token,
            user: UserSerializer.new(user)
          }, status: :ok
        else
          render json: {
            error: 'Invalid username/password'
          }, status: :unauthorized
        end
      end

      swagger_api :validate_token do |_api|
        summary 'API for validate auth token'
        param :header,
              'Authorization',
              :string,
              :required,
              'Authentication token'

        response :unauthorized
      end

      def validate_token
        load_current_user!
        render json: {
          success: 'Token valid',
          user: UserSerializer.new(current_user)
        }, status: :ok
      rescue StandardError
        render json: {
          error: 'Token invalid'
        }, status: :unauthorized
      end
    end
  end
end
