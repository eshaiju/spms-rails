# frozen_string_literal: true

module Api
  module V1
    class DashboardController < ApplicationController
      before_action :authenticate_request!
      respond_to :json

      swagger_controller :dashboard, 'Dashboard'

      swagger_api :index do |_api|
        summary 'lists detials of dashboard'
        param :header,
              'Authorization',
              :string,
              :required,
              'Authentication token'
        param :query, :start_date, :date, :optional

        response :ok, 'Success', :Dashboard
        response :not_found
      end

      def index
        dashboard = DashboardService.new(params, current_user)
        render json: {
          dashboard: DashboardSerializer.new(dashboard)
        }, status: :ok
      end
    end
  end
end
