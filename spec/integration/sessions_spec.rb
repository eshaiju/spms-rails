# frozen_string_literal: true

RSpec.describe 'Session' do
  path '/api/v1/login' do
    post 'login' do
      tags 'Session'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :session, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: %i[email password password_confirmation]
      }

      response '200', 'created' do
        before do
          @user = FactoryBot.create(:user, password: '12345678', password_confirmation: '12345678')
          @user.confirm
        end

        let(:session) { { email: @user.email, password: @user.password, password_confirmation: @user.password_confirmation } }

        run_test!
      end
    end
  end

  path '/api/v1/validate_token' do
    post 'validate_token' do
      tags 'Session'

      consumes 'application/json'
      produces 'application/json'

      parameter(
        in: :header,
        type: :string,
        name: 'Authorization',
        required: true,
        description: 'Authentication token'
      )

      response '200', 'created' do
        before do
          @user = FactoryBot.create(:user, password: '12345678', password_confirmation: '12345678')
          @user.confirm
        end

        let(:Authorization) { JsonWebToken.encode(user_id: @user.id) }

        run_test!
      end
    end
  end
end
