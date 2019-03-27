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
      parameter name: :project_id, in: :query, type: :integer, optional: true
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

  path '/api/v1/tickets' do
    post 'Create a ticket' do
      tags 'Ticket'
      consumes 'application/json'
      produces 'application/json'
      parameter(
        in: :header,
        type: :string,
        name: 'Authorization',
        required: true,
        description: 'Authentication token'
      )

      parameter name: :ticket, in: :body, schema: {
        type: :object,
        properties: {
          ticket: {
            properties: {
              title: { type: :string },
              ticket_no: { type: :string },
              description: { type: :string },
              category: { type: :string },
              status: { type: :status },
              maximum_permitted_time: { type: :string },
              start_date: { type: :string },
              end_date: { type: :string },
              project_id: { type: :integer },
              assigned_user_id: { type: :integer },
              created_user_id: { type: :integer },
              created_user_type: { type: :string }
            }
          }
        },
        required: %i[title ticket_no start_date project_id created_user_id created_user_type]
      }

      response '201', '' do
        let(:user) { FactoryBot.create(:user, password: '12345678', password_confirmation: '12345678') }
        let(:Authorization) { JsonWebToken.encode(user_id: user.id) }
        let(:project) { FactoryBot.create(:project, manager: user) }
        let(:ticket) do
          FactoryBot.attributes_for(:ticket,
                                    project_id: project.id,
                                    created_user_id: user.id,
                                    created_user_type: user.class.name)
        end

        run_test!
      end

      response '401', '' do
        let(:Authorization) { '' }
        let(:ticket) { {} }
        run_test!
      end
    end
  end

  path '/api/v1/tickets/{id}/' do
    put 'Updates ticket' do
      tags 'Ticket'
      consumes 'application/json'
      produces 'application/json'
      parameter(
        in: :header,
        type: :string,
        name: 'Authorization',
        required: true,
        description: 'Authentication token'
      )

      parameter name: :id, in: :path, type: :string

      parameter name: :ticket, in: :body, schema: {
        type: :object,
        properties: {
          ticket: {
            properties: {
              title: { type: :string },
              ticket_no: { type: :string },
              description: { type: :string },
              category: { type: :string },
              status: { type: :status },
              maximum_permitted_time: { type: :string },
              start_date: { type: :string },
              end_date: { type: :string },
              assigned_user_id: { type: :integer },
              created_user_id: { type: :integer },
              created_user_type: { type: :string }
            }
          }
        }
      }

      let(:user) { FactoryBot.create(:user, password: '12345678', password_confirmation: '12345678') }
      let(:Authorization) { JsonWebToken.encode(user_id: user.id) }
      let(:project) { FactoryBot.create(:project, manager: user) }
      let(:ticket) do
        FactoryBot.create(:ticket,
                          project: project,
                          created_user: user)
      end

      response '200', 'ticket updated' do
        let(:id) { ticket.id }
        run_test!
      end
    end

    path '/api/v1/tickets/{id}/' do
      delete 'Delete ticket' do
        tags 'Ticket'
        consumes 'application/json'
        produces 'application/json'
        parameter(
          in: :header,
          type: :string,
          name: 'Authorization',
          required: true,
          description: 'Authentication token'
        )

        parameter name: :id, in: :path, type: :string

        let(:user) { FactoryBot.create(:user, password: '12345678', password_confirmation: '12345678') }
        let(:Authorization) { JsonWebToken.encode(user_id: user.id) }
        let(:project) { FactoryBot.create(:project, manager: user) }
        let(:ticket) do
          FactoryBot.create(:ticket,
                            project: project,
                            created_user: user)
        end

        response '200', 'ticket deleted' do
          let(:id) { ticket.id }
          run_test!
        end
      end
    end
  end
end
