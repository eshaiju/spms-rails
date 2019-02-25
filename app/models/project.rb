# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :manager, class_name: 'User'
  has_many :users, through: :users_projects

  validates :name, presence: true, uniqueness: true
end
