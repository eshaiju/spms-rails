# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_request!, except: [:create]
      respond_to :json

      swagger_controller :users, 'Users'

      swagger_api :me do |_api|
        summary 'shows logged in user details'
        param :header, 'Authorization', :string, :required, 'Authentication token'
        response :ok, 'Success', :User
        response :not_found
      end

      def me
        respond_with UserSerializer.new(
          current_user,
          params: { include: [:projects] }
        )
      end

      swagger_api :create do |_api|
        summary 'Create a user'
        param :form, 'user[email]', :string, :required
        param :form, 'user[first_name]', :string, :required
        param :form, 'user[last_name]', :string, :required
        param :form, 'user[emp_id]', :string, :required
        param :form, 'user[designation]', :string, :required
        param :form, 'user[password]', :string, :required
        param :form, 'user[password_confirmation]', :string, :required

        response :bad_request
      end

      def create
        user = User.new(user_params)

        if user.save
          render json: { status: 'User created successfully', user: UserSerializer.new(user) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :bad_request
        end
      end

      swagger_api :update do |_api|
        summary 'Updates logged in user User'
        param :header, 'Authorization', :string, :required, 'Authentication token'
        param :form, 'user[email]', :string, :optional
        param :form, 'user[first_name]', :string, :optional
        param :form, 'user[last_name]', :string, :optional
        param :form, 'user[emp_id]', :string, :optional
        param :form, 'user[designation]', :string, :optional
        param :form, 'user[password]', :string, :optional
        param :form, 'user[password_confirmation]', :string, :optional

        response :unauthorized
        response :bad_request
      end

      def update
        if current_user.update(user_params)
          render json: { user: UserSerializer.new(current_user), status: 'User updated successfully' }, status: :ok
        else
          render json: { errors: current_user.errors.full_messages }, status: 422
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
