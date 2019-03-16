# frozen_string_literal: true

module Api
  module V1
    class TicketsController < ApplicationController
      before_action :authenticate_request!
      respond_to :json

      def index
        tickets = TicketService.new(params, current_user).all
        render json: {
          tickets: TicketSerializer.new(tickets)
        }, status: :ok
      end
    end
  end
end
