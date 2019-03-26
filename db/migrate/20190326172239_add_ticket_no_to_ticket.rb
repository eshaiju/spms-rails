class AddTicketNoToTicket < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :ticket_no, :string
  end
end
