# frozen_string_literal: true

class TicketSerializer < BaseSerializer
  attributes :id, :title, :ticket_no, :project_id, :description, :category, :status, :maximum_permitted_time, :start_date, :end_date

  attribute :assigned_user do |object|
    UserSerializer.new(object.assigned_user, fields: { user: [:name] })
  end

  attribute :project do |object|
    ProjectSerializer.new(object.project, fields: { project: [:name] })
  end
end
