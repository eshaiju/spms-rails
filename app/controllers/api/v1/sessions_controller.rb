# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      def login
        user = User.find_by(email: params[:email].to_s.downcase)

        if user&.valid_password?(params[:password])
          sign_in(:user, user)
          auth_token = JsonWebToken.encode(user_id: user.id)
          render json: {
            auth_token: auth_token,
            user: UserSerializer.new(
              user,
              params: { include: [:projects] }
            )
          }, status: :ok
        else
          render json: {
            error: 'Invalid username/password'
          }, status: :unauthorized
        end
      end

      def validate_token
        load_current_user!
        render json: {
          success: 'Token valid',
          user: UserSerializer.new(
              current_user,
              params: { include: [:projects] }
            )
        }, status: :ok
      rescue StandardError
        render json: {
          error: 'Token invalid'
        }, status: :unauthorized
      end
    end
  end
end
