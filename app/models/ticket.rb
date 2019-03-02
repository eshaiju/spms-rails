# frozen_string_literal: true

class Ticket < ApplicationRecord
  belongs_to :project
  belongs_to :created_user, polymorphic: true
  belongs_to :assigned_user, class_name: 'User', optional: true

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

  def self.states
    {
      idea: 'Idea',
      defined: 'Defined',
      in_progress: 'In-Progress',
      completed: 'Completed',
      accepted: 'Accepted',
      released: 'Released'
    }
  end
end
