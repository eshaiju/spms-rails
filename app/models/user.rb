# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  before_save :downcase_email

  validates :email, presence: true, uniqueness: true, format: {
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
    message: 'Invalid email'
  }

  def downcase_email
    self.email = email.delete(' ').downcase
  end
end
