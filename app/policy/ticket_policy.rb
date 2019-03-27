# frozen_string_literal: true

class TicketPolicy
  attr_reader :current_user, :resource

  def initialize(current_user:, resource:)
    @current_user = current_user
    @resource = resource
  end

  def destroy?
    current_user == resource.created_user
  end
end
