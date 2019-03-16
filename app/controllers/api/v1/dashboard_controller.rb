# frozen_string_literal: true

module Api
  module V1
    class DashboardController < ApplicationController
      before_action :authenticate_request!
      respond_to :json

      def index
        dashboard = DashboardService.new(params, current_user)
        render json: {
          dashboard: DashboardSerializer.new(dashboard)
        }, status: :ok
      end
    end
  end
end
