# frozen_string_literal: true

class TicketActivityLog < ApplicationRecord
  belongs_to :ticket
  belongs_to :user

  validates :activity, :log_date, :log_time, presence: true

  delegate :title, :id, to: :ticket, prefix: :ticket, allow_nil: true
  delegate :ticket_no, to: :ticket, allow_nil: true
end
