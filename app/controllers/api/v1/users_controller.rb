# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_request!, except: [:create]
      respond_to :json

      def me
        respond_with UserSerializer.new(
          current_user,
          params: { include: [:projects] }
        )
      end

      def create
        user = User.new(user_params)

        if user.save
          render json: {
            status: 'User created successfully',
            user: UserSerializer.new(user)
          }, status: :created
        else
          render json: {
            errors: user.errors.full_messages
          }, status: :bad_request
        end
      end

      def update
        if current_user.update(user_params)
          render json: {
            user: UserSerializer.new(current_user),
            status: 'User updated successfully'
          }, status: :ok
        else
          render json: {
            errors: current_user.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(
          :first_name,
          :last_name,
          :emp_id,
          :designation,
          :email,
          :password,
          :password_confirmation
        )
      end
    end
  end
end
