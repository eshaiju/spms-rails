# frozen_string_literal: true

class TicketActivityLogSerializer < BaseSerializer
  attributes :id, :activity, :log_time, :log_date, :status, :ticket_title, :ticket_id, :ticket_no

  attribute :user do |object|
    UserSerializer.new(object.user, fields: { user: [:name] })
  end
end
