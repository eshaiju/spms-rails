# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :client_name
      t.date :start_date
      t.integer :manager_id, foreign_key: true

      t.timestamps
    end

    add_index :projects, :name, unique: true
  end
end
