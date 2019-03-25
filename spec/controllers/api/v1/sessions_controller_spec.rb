# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::SessionsController do
  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
    @user = FactoryBot.create(:user, password: '12345678', password_confirmation: '12345678')
    @user.confirm
    @project = FactoryBot.create(:project)
    @users_project = FactoryBot.create(:users_project, user_id: @user.id, project_id: @project.id)
  end

  describe 'POST #login' do
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

      it 'returns the projects of current user' do
        expect(json_response[:user][:data][:attributes][:projects][:data][0][:id]).to eql @project.id.to_s
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

  describe 'POST #validate_token' do
    context 'when the credentials are correct' do
      before(:each) do
        api_authorization_header JsonWebToken.encode(user_id: @user.id)
        post :validate_token
      end

      it 'returns the user record corresponding to the given auth token' do
        expect(json_response[:user][:data][:attributes][:email]).to eql @user.email
      end

      it 'returns the projects of current user' do
        expect(json_response[:user][:data][:attributes][:projects][:data][0][:id]).to eql @project.id.to_s
      end

      it { should respond_with 200 }
    end

    context 'when the credentials are incorrect' do
      before(:each) do
        api_authorization_header 'invalid token'
        post :validate_token
      end

      it 'returns a json with an error' do
        expect(json_response[:error]).to eql 'Token invalid'
      end

      it { should respond_with 401 }
    end
  end
end
