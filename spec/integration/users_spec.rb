# frozen_string_literal: true

require 'swagger_helper'

describe 'Users API' do
  path '/api/v1/users/me' do
    get 'Retrieves logged in user details' do
      tags 'Users'
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

  path '/api/v1/users' do
    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            properties: {
              email: { type: :string },
              first_name: { type: :string },
              last_name: { type: :string },
              emp_id: { type: :string },
              designation: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string }
            }
          }
        },
        required: %i[email first_name last_name emp_id designation password password_confirmation]
      }

      let(:user) { { user: FactoryBot.attributes_for(:user) } }
      let(:Authorization) { JsonWebToken.encode(user_id: user.id) }
      response '201', 'user created' do
        run_test!
      end

      response '400', 'bad request' do
        let(:user) { { user: { email: 'example@email.com' } } }
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}/' do
    put 'Updates logged in user' do
      tags 'Users'
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

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            properties: {
              email: { type: :string },
              first_name: { type: :string },
              last_name: { type: :string },
              emp_id: { type: :string },
              designation: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string }
            }
          }
        }
      }

      let(:user) { FactoryBot.create(:user) }
      let(:Authorization) { JsonWebToken.encode(user_id: user.id) }
      
      response '200', 'user updated' do
        let(:id) { user.id }
        run_test!
      end
    end
  end
end
