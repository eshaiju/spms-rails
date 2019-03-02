class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.string :title
      t.text :description
      t.references :project, foreign_key: true
      t.string :status
      t.integer :maximum_permitted_time
      t.integer :created_user_id
      t.integer :assigned_user_id
      t.string :category
      t.date :start_date
      t.date :end_date

      t.timestamps
    end

    add_index :tickets, :title
    add_index :tickets, :start_date
    add_index :tickets, :end_date
  end
end
