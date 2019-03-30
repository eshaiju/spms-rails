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
    activity_logs = current_user.ticket_activity_logs.includes(:ticket)
    activity_logs = activity_logs.where('log_date >= ?', start_date) if start_date.present?
    activity_logs
  end

  def total_hours_in_current_month
    activities_of_current_month.pluck(:log_time).sum
  end

  def total_hours_in_previous_month
    activities_of_previous_month.pluck(:log_time).sum
  end

  def total_activities_of_current_month
    activities_of_current_month.count
  end

  def total_tickets_of_current_month
    tickets_of_current_month.count
  end

  def activities_of_current_month
    current_user.ticket_activity_logs.where('log_date >= ?', beginning_of_month)
  end

  def activities_of_previous_month
    current_user.ticket_activity_logs.where('log_date >= ? and log_date < ?', beginning_of_previous_month, beginning_of_month)
  end

  def tickets_of_current_month
    current_user.tickets.where('start_date >= ?', beginning_of_month)
  end

  def beginning_of_month
    Time.zone.now.at_beginning_of_month
  end

  def beginning_of_previous_month
    (Time.zone.now - 1.month).at_beginning_of_month
  end

  delegate :id, to: :current_user

  def start_date
    Date.parse(params[:start_date]) if params[:start_date]
  end
end
