# frozen_string_literal: true

class UserSerializer < BaseSerializer
  attributes :name, :first_name, :last_name, :emp_id, :email, :designation

  attribute :projects, if: proc { |_record, params| include_model?(params, :projects) } do |object|
    ProjectSerializer.new(object.projects)
  end
end
