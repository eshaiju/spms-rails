# frozen_string_literal: true

class DashboardSerializer < BaseSerializer
  attributes :id, :total_hours_in_current_month, :total_activities_of_current_month, :total_tickets_of_current_month, :total_hours_in_previous_month

  attribute :projects do |object|
    ProjectSerializer.new(object.projects, fields: { project: [:name] })
  end

  attribute :tickets do |object|
    TicketSerializer.new(object.tickets, fields: { ticket: %i[title start_date end_date] })
  end

  attribute :ticket_activity_logs do |object|
    TicketActivityLogSerializer.new(object.ticket_activity_logs, fields: { ticket_activity_logs: %i[activity log_date log_time ticket_title] })
  end
end
