# frozen_string_literal: true

require 'swagger_helper'

describe 'Ticket API' do
  path '/api/v1/tickets' do
    get 'Retrieves all tickets of project and user' do
      tags 'Ticket'
      produces 'application/json'
      parameter(
        in: :header,
        type: :string,
        name: 'Authorization',
        required: true,
        description: 'Authentication token'
      )
      parameter name: :project_id, in: :query, type: :integer, required: true
      parameter name: :assigned_user_id, in: :query, type: :integer, required: true
      parameter name: :page, in: :query, type: :integer, optional: true

      response '200', '' do
        let(:user) { FactoryBot.create(:user) }
        let(:Authorization) { JsonWebToken.encode(user_id: user.id) }
        let(:project) { FactoryBot.create(:project) }
        let(:ticket) do
          FactoryBot.create(:ticket,
                            created_user: user,
                            assigned_user_id: user.id,
                            project_id: project.id)
        end
        let(:project_id) { project.id }
        let(:assigned_user_id) { user.id }
        let(:page) { 0 }
        run_test!
      end

      response '401', '' do
        let(:Authorization) { '' }
        let(:project_id) { '' }
        let(:assigned_user_id) { '' }
        let(:page) { 0 }
        run_test!
      end
    end
  end
end
