# frozen_string_literal: true

class TicketService
  def initialize(params, current_user)
    @current_user = current_user
    @params = params
  end

  def all
    tickets = Ticket.all.includes(:project, :assigned_user)
    tickets = tickets.where(project_id: project_id) if project_id.present?
    tickets = tickets.where(assigned_user_id: assigned_user_id) if assigned_user_id.present?
    tickets.page(page) if page.present?
    tickets.order(id: :desc)
  end

  private

  def project_id
    @params[:project_id]
  end

  def assigned_user_id
    @params[:assigned_user_id]
  end

  def page
    @params[:page]
  end
end
