# frozen_string_literal: true

class Ticket < ApplicationRecord
  belongs_to :project
  has_one :created_user, class_name: 'User'
  has_one :assigned_user, class_name: 'User'

  validates :title, presence: true, uniqueness: true
  validates :start_date, :category, presence: true

  def self.categories
    {
      feature: 'Feature',
      bug: 'Bug',
      chore: 'Chore',
      support: 'Support'
    }
  end
end
