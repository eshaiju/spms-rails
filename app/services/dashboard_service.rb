# frozen_string_literal: true

class DashboardService
  attr_reader :current_user, :params

  def initialize(params, current_user)
    @current_user = current_user
    @params = params
  end

  delegate :projects, to: :current_user

  def tickets
    tickets = current_user.tickets
    tickets = tickets.where('start_date >= ?', start_date) if start_date.present?
    tickets
  end

  def ticket_activity_logs
    activity_logs = current_user.ticket_activity_logs
    activity_logs = activity_logs.where('log_date >= ?', start_date) if start_date.present?
    activity_logs
  end

  delegate :id, to: :current_user

  def start_date
    Date.parse(params[:start_date]) if params[:start_date]
  end
end
