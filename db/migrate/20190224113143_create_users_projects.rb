# frozen_string_literal: true

class CreateUsersProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :users_projects do |t|
      t.references :user, foreign_key: true
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
