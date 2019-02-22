# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::SessionsController do
  describe 'POST #login' do
    before(:each) do
      @user = FactoryBot.create :user
    end

    context 'when the credentials are correct' do
      before(:each) do
        credentials = { email: @user.email, password: '12345678' }
        post :login, params: credentials
      end

      it 'returns the user record corresponding to the given credentials' do
        @user.reload
        auth_token = JsonWebToken.encode(user_id: @user.id)

        expect(json_response[:auth_token]).to eql auth_token
      end

      it { should respond_with 200 }
    end

    context 'when the credentials are incorrect' do
      before(:each) do
        credentials = { email: @user.email, password: 'invalidpassword' }
        post :login, params: credentials
      end

      it 'returns a json with an error' do
        expect(json_response[:error]).to eql 'Invalid username/password'
      end

      it { should respond_with 401 }
    end
  end
end
