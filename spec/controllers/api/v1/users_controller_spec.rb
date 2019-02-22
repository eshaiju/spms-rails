# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::UsersController do
  describe 'GET #show' do
    before(:each) do
      @user = FactoryBot.create :user
      get :show, params: { id: @user.id }, format: :json
    end

    it 'returns the information about a reporter on a hash' do
      expect(json_response[:email]).to eql @user.email
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        @user_attributes = FactoryBot.attributes_for :user
        post :create, params: { user: @user_attributes }
      end

      it 'renders the json representation for the user record just created' do
        expect(json_response[:user][:email]).to eql @user_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        @invalid_user_attributes = { password: '12345678',
                                     password_confirmation: '12345678' }
        post :create, params: { user: @invalid_user_attributes }, format: :json
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        expect(json_response[:errors]).to include "Email can't be blank"
      end

      it { should respond_with 400 }
    end
  end

  describe 'PUT/PATCH #update' do
    context 'when is successfully updated' do
      before(:each) do
        @user = FactoryBot.create :user
        patch :update, params: { id: @user.id,
                                 user: { email: 'email@example.com' } }, format: :json
      end

      it 'renders the json representation for the updated user' do
        expect(json_response[:user][:email]).to eql 'email@example.com'
      end

      it { should respond_with 200 }
    end

    context 'when is not created' do
      before(:each) do
        @user = FactoryBot.create :user
        patch :update, params: { id: @user.id,
                                 user: { email: 'bademail.com' } }, format: :json
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on whye the user could not be created' do
        expect(json_response[:errors]).to include 'Email Invalid email'
      end

      it { should respond_with 422 }
    end
  end
end
