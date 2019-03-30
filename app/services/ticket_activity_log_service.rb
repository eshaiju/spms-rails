# frozen_string_literal: true

class TicketActivityLogService
  def initialize(params, current_user)
    @current_user = current_user
    @params = params
  end

  def all
    activity_logs = TicketActivityLog.all.includes(:ticket, :user)
    activity_logs = activity_logs.where(ticket_id: ticket_id) if ticket_id.present?
    activity_logs = activity_logs.where(user: user_id) if user_id.present?
    activity_logs.page(page) if page.present?
    activity_logs.order(id: :desc)
  end

  private

  def ticket_id
    @params[:ticket_id]
  end

  def user_id
    @params[:user_id]
  end

  def page
    @params[:page]
  end
end
