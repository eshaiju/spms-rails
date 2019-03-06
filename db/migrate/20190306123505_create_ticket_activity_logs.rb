class CreateTicketActivityLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_activity_logs do |t|
      t.references :ticket, foreign_key: true
      t.references :user, foreign_key: true
      t.float :log_time
      t.date :log_date
      t.string :activity
      t.integer :approved_by
      t.string :status

      t.timestamps
    end

    add_index :ticket_activity_logs, :log_date
    add_index :ticket_activity_logs, :approved_by
  end
end
