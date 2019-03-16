# frozen_string_literal: true

require 'swagger_helper'

describe 'Users Projects API' do
  path '/api/v1/my_projects' do
    get 'Retrieves all projects of logged in user' do
      tags 'UsersProjects'
      produces 'application/json'
      parameter(
        in: :header,
        type: :string,
        name: 'Authorization',
        required: true,
        description: 'Authentication token'
      )

      response '200', '' do
        let(:user) { FactoryBot.create(:user, password: '12345678', password_confirmation: '12345678') }
        let(:Authorization) { JsonWebToken.encode(user_id: user.id) }
        run_test!
      end

      response '401', '' do
        let(:Authorization) { '' }
        run_test!
      end
    end
  end
end
