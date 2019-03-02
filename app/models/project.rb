# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :manager, class_name: 'User'
  has_many :users_projects, dependent: :destroy
  has_many :users, through: :users_projects
  has_many :tickets, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
