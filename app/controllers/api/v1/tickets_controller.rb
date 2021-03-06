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

      def create
        ticket = Ticket.new(ticket_params)
        if ticket.save
          render json: {
            status: 'Ticket created successfully',
            ticket: TicketSerializer.new(ticket)
          }, status: :created
        else
          render json: {
            errors: ticket.errors.full_messages
          }, status: :bad_request
        end
      end

      def update
        ticket = Ticket.find_by(id: params[:id])
        return not_found if ticket.blank?

        if ticket.update(ticket_params)
          render json: {
            ticket: TicketSerializer.new(ticket),
            status: 'Ticket updated successfully'
          }, status: :ok
        else
          render json: {
            errors: ticket.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        @ticket = Ticket.find_by(id: params[:id])

        return not_found if @ticket.blank?
        return invalid_authentication unless ticket_policy.destroy?

        if ticket_policy.destroy? && @ticket.destroy
          render json: {
            status: 'Ticket deleted successfully'
          }, status: :ok
        else
          render json: {
            errors: @ticket.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      private

      def ticket_params
        params.require(:ticket).permit(
          :title,
          :ticket_no,
          :description,
          :project_id,
          :category,
          :status,
          :maximum_permitted_time,
          :start_date,
          :end_date,
          :assigned_user_id,
          :created_user_id,
          :created_user_type
        )
      end

      def ticket_policy
        @ticket_policy ||= TicketPolicy.new(current_user: current_user, resource: @ticket)
      end
    end
  end
end
