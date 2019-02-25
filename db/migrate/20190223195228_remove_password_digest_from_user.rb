# frozen_string_literal: true

class RemovePasswordDigestFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :password_digest
  end
end
