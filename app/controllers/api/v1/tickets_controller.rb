# frozen_string_literal: true

module Api
  module V1
    class TicketsController < ApplicationController
      before_action :authenticate_request!
      respond_to :json

      swagger_controller :tickets, 'Tickets'

      swagger_api :index do |_api|
        summary 'lists tickets of a project'
        param :header,
              'Authorization',
              :string,
              :required,
              'Authentication token'
        param :query, :project_id, :integer, :required
        param :query, :assigned_user_id, :integer, :required
        param :query, :page, :integer, :optional

        response :ok, 'Success', :Task
        response :not_found
      end

      def index
        tickets = TicketService.new(params, current_user).all
        render json: {
          tickets: TicketSerializer.new(tickets)
        }, status: :ok
      end
    end
  end
end
