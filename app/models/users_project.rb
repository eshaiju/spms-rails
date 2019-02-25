# frozen_string_literal: true

class UsersProject < ApplicationRecord
  belongs_to :user
  belongs_to :project
end
