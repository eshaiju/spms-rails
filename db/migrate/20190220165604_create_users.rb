# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :emp_id
      t.string :designation
      t.string :password_digest

      t.timestamps
    end
  end
end
