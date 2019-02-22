# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      respond_to :json

      swagger_controller :users, 'Users'

      swagger_api :show do |_api|
        summary "Fetches a single User item"
        param :path, :id, :integer, :required, "User Id"
        response :ok, "Success", :User
        response :not_found
      end

      def show
        respond_with User.find(params[:id])
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
          render json: { status: 'User created successfully', user: user }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :bad_request
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
