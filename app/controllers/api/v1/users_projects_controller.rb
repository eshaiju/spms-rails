# frozen_string_literal: true

module Api
  module V1
    class UsersProjectsController < ApplicationController
      before_action :authenticate_request!
      respond_to :json

      swagger_controller :users_projects, 'UsersProjects'

      swagger_api :my_projects do |_api|
        summary 'shows logged in users project details'
        param :header,
              'Authorization',
              :string,
              :required,
              'Authentication token'
        response :ok, 'Success', :Project
        response :not_found
      end

      def my_projects
        respond_with ProjectSerializer.new(
          current_user.projects
        )
      end
    end
  end
end
