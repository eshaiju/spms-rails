# frozen_string_literal: true

class TicketActivityLog < ApplicationRecord
  belongs_to :ticket
  belongs_to :user

  validates :activity, :log_date, :log_time, presence: true
end
