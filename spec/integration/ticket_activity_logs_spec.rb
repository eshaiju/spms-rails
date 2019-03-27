# frozen_string_literal: true

require 'swagger_helper'

describe 'Ticket Activity Log API' do
  path '/api/v1/ticket_activity_logs' do
    get 'Retrieves all ticket activity logs of ticket and user' do
      tags 'TicketActivityLog'
      produces 'application/json'
      parameter(
        in: :header,
        type: :string,
        name: 'Authorization',
        required: true,
        description: 'Authentication token'
      )
      parameter name: :ticket_id, in: :query, type: :integer, optional: true
      parameter name: :user_id, in: :query, type: :integer, required: true
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
        let(:ticket_activity_log) do
          FactoryBot.create(:ticket_activity_log,
                            ticket_id: ticket.id,
                            user_id: user.id)
        end
        let(:ticket_id) { project.id }
        let(:user_id) { user.id }
        let(:page) { 0 }
        run_test!
      end

      response '401', '' do
        let(:Authorization) { '' }
        let(:ticket_id) { '' }
        let(:user_id) { '' }
        let(:page) { 0 }
        run_test!
      end
    end
  end

  path '/api/v1/ticket_activity_logs' do
    post 'Create a ticket activity log' do
      tags 'TicketActivityLog'
      consumes 'application/json'
      produces 'application/json'
      parameter(
        in: :header,
        type: :string,
        name: 'Authorization',
        required: true,
        description: 'Authentication token'
      )

      parameter name: :ticket_activity_log, in: :body, schema: {
        type: :object,
        properties: {
          ticket_activity_log: {
            properties: {
              ticket_id: { type: :integer },
              user_id: { type: :integer },
              log_time: { type: :number },
              log_date: { type: :string },
              activity: { type: :string }
            }
          }
        },
        required: %i[ticket_id user_id log_time log_date activity]
      }

      response '201', '' do
        let(:user) { FactoryBot.create(:user, password: '12345678', password_confirmation: '12345678') }
        let(:Authorization) { JsonWebToken.encode(user_id: user.id) }
        let(:project) { FactoryBot.create(:project, manager: user) }
        let(:ticket) do
          FactoryBot.create(:ticket,
                            project: project,
                            created_user: user)
        end
        let(:ticket_activity_log) do
          { ticket_activity_log: FactoryBot.attributes_for(:ticket_activity_log,
                                                           ticket_id: ticket.id,
                                                           user_id: user.id) }
        end

        run_test!
      end

      response '401', '' do
        let(:Authorization) { '' }
        let(:ticket_activity_log) { {} }
        run_test!
      end
    end
  end

  path '/api/v1/ticket_activity_logs/{id}/' do
    put 'Updates ticket activity log' do
      tags 'TicketActivityLog'
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

      parameter name: :ticket_activity_log, in: :body, schema: {
        type: :object,
        properties: {
          ticket_activity_log: {
            properties: {
              ticket_id: { type: :integer },
              user_id: { type: :integer },
              log_time: { type: :number },
              log_date: { type: :string },
              activity: { type: :string }
            }
          }
        },
        required: %i[ticket_id user_id log_time log_date activity]
      }

      let(:user) { FactoryBot.create(:user, password: '12345678', password_confirmation: '12345678') }
      let(:Authorization) { JsonWebToken.encode(user_id: user.id) }
      let(:project) { FactoryBot.create(:project, manager: user) }
      let(:ticket) do
        FactoryBot.create(:ticket,
                          project: project,
                          created_user: user)
      end
      let(:ticket_activity_log) do
        FactoryBot.create(:ticket_activity_log,
                          ticket_id: ticket.id,
                          user_id: user.id)
      end

      response '200', 'ticket activity log updated' do
        let(:id) { ticket_activity_log.id }
        run_test!
      end
    end
  end
end
