# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::TicketsController do
  before do
    @user = FactoryBot.create(:user)
    @user.confirm
    api_authorization_header JsonWebToken.encode(user_id: @user.id)
  end

  describe 'GET #index' do
    before do
      project = FactoryBot.create(:project)
      @ticket = FactoryBot.create(:ticket,
                                  created_user: @user,
                                  assigned_user_id: @user.id,
                                  project_id: project.id)
      get :index, params: { assigned_user_id: @user.id, project_id: project.id }, format: :json
    end

    it 'returns the information about tickets of a project' do
      expect(json_response[:tickets][:data][0][:attributes][:title]).to eql @ticket.title
    end

    it 'returns the information about assigned user details of ticket' do
      expect(json_response[:tickets][:data][0][:attributes][:assigned_user][:data][:id]).to eql @ticket.assigned_user.id.to_s
    end

    it { is_expected.to respond_with 200 }
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before do
        project = FactoryBot.create(:project, manager: @user)
        @ticket_attributes = FactoryBot.attributes_for(:ticket,
                                                       project_id: project.id,
                                                       created_user_id: @user.id,
                                                       created_user_type: @user.class.name)

        post :create, params: { ticket: @ticket_attributes }
      end

      it 'renders the json representation for the ticket record just created' do
        expect(json_response[:ticket][:data][:attributes][:title]).to eql @ticket_attributes[:title]
      end

      it { is_expected.to respond_with 201 }
    end

    context 'when is not created' do
      before do
        @invalid_ticket_attributes = FactoryBot.attributes_for(:ticket)
        post :create, params: { ticket: @invalid_ticket_attributes }, format: :json
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        expect(json_response[:errors]).to include 'Project must exist'
      end

      it { is_expected.to respond_with 400 }
    end
  end

  describe 'PUT/PATCH #update' do
    before do
      project = FactoryBot.create(:project, manager: @user)
      @ticket = FactoryBot.create(:ticket,
                                  project: project,
                                  created_user: @user)
    end

    context 'when is successfully updated' do
      before do
        patch :update, params: { id: @ticket.id,
                                 ticket: { status: 'completed' } }, format: :json
        @ticket.reload
      end

      it 'renders the json representation for the updated user' do
        expect(json_response[:ticket][:data][:attributes][:status]).to eql 'completed'
      end

      it { is_expected.to respond_with 200 }
    end

    context 'when is not created' do
      before do
        patch :update, params: { id: @ticket.id,
                                 ticket: { start_date: nil } }, format: :json
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on whye the user could not be created' do
        expect(json_response[:errors]).to include "Start date can't be blank"
      end

      it { is_expected.to respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    before do
      @project = FactoryBot.create(:project, manager: @user)
    end

    context 'when is successfully deleted' do
      before do
        @ticket = FactoryBot.create(:ticket,
                                    project: @project,
                                    created_user: @user)
      end

      before do
        delete :destroy, params: { id: @ticket.id }, format: :json
      end

      it { is_expected.to respond_with 200 }
    end

    context 'when unauthorized' do
      before do
        @another_user = FactoryBot.create(:user)
        @ticket = FactoryBot.create(:ticket,
                                    project: @project,
                                    created_user: @another_user)
      end

      before do
        delete :destroy, params: { id: @ticket.id }, format: :json
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:error)
      end

      it 'renders the json errors on why the ticket could not be deleted' do
        expect(json_response[:error]).to eq 'unauthorized'
      end

      it { is_expected.to respond_with 401 }
    end
  end
end
