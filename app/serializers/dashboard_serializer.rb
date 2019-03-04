# frozen_string_literal: true

class DashboardSerializer < BaseSerializer
  attributes :id

  attribute :projects do |object|
    ProjectSerializer.new(object.projects, fields: { project: [:name] })
  end

  attribute :tickets do |object|
    TicketSerializer.new(object.tickets, fields: { ticket: %i[title start_date end_date] })
  end
end
