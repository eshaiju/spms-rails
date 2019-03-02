# frozen_string_literal: true

class ProjectSerializer < BaseSerializer
  attributes :id, :name, :client_name

  attribute :manager do |object|
    UserSerializer.new(object.manager, fields: { user: [:name] })
  end
end
