# frozen_string_literal: true

require 'swagger_helper'

describe 'Dashboard API' do
  path '/api/v1/dashboard' do
    get 'Retrieves all detials of dashboard' do
      tags 'Dashboard'
      produces 'application/json'
      parameter(
        in: :header,
        type: :string,
        name: 'Authorization',
        required: true,
        description: 'Authentication token'
      )
      parameter name: :start_date, in: :query, type: :date

      response '200', '' do
        let(:user) { FactoryBot.create(:user, password: '12345678', password_confirmation: '12345678') }
        let(:Authorization) { JsonWebToken.encode(user_id: user.id) }
        let(:start_date) { Time.zone.today }
        run_test!
      end

      response '401', '' do
        let(:Authorization) { '' }
        let(:start_date) { Time.zone.today }
        run_test!
      end
    end
  end
end
