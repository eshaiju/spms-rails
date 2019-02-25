# frozen_string_literal: true

class User < ApplicationRecord
  has_many :users_projects
  has_many :projects, through: :users_projects
  has_many :managed_projects, through: :projects, foreign_key: :manager_id

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable

  before_save :downcase_email

  validates :email, presence: true, uniqueness: true, format: {
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
    message: 'Invalid email'
  }

  def downcase_email
    self.email = email.delete(' ').downcase
  end

  def self.designations
    {
      developer: 'Developer',
      qa: 'QA',
      manager: 'Manager'
    }
  end
end
