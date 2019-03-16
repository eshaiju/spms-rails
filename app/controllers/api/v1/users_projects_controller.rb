# frozen_string_literal: true

module Api
  module V1
    class UsersProjectsController < ApplicationController
      before_action :authenticate_request!
      respond_to :json

      def my_projects
        respond_with ProjectSerializer.new(
          current_user.projects
        )
      end
    end
  end
end
