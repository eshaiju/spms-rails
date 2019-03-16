# frozen_string_literal: true

module Api
  module V1
    class TicketActivityLogsController < ApplicationController
      before_action :authenticate_request!
      respond_to :json

      def create
        ticket_activity = TicketActivityLog.new(ticket_activity_log_params)

        if ticket_activity.save
          render json: {
            status: 'Ticket activity log created successfully',
            ticket_activity_log: TicketActivityLogSerializer.new(ticket_activity)
          }, status: :created
        else
          render json: {
            errors: ticket_activity.errors.full_messages
          }, status: :bad_request
        end
      end

      def update
        ticket_activity = TicketActivityLog.find_by(id: params[:id])

        if ticket_activity.update(ticket_activity_log_params)
          render json: {
            ticket_activity_log: TicketActivityLogSerializer.new(ticket_activity),
            status: 'Ticket activity log updated successfully'
          }, status: :ok
        else
          render json: {
            errors: ticket_activity.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      private

      def ticket_activity_log_params
        params.require(:ticket_activity_log).permit(
          :ticket_id,
          :user_id,
          :log_time,
          :log_date,
          :activity,
          :approved_by,
          :status
        )
      end
    end
  end
end
