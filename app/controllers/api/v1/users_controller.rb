# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      swagger_controller :users, 'Users'

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
          render json: { status: 'User created successfully' }, status: :created
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
