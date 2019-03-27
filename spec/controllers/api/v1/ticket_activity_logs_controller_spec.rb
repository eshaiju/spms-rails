# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::TicketActivityLogsController do
  before do
    @user = FactoryBot.create(:user)
    @user.confirm
    api_authorization_header JsonWebToken.encode(user_id: @user.id)
    project = FactoryBot.create(:project)
    @ticket = FactoryBot.create(:ticket,
                                created_user: @user,
                                assigned_user_id: @user.id,
                                project_id: project.id)
  end

  describe 'GET #index' do
    before do
      @ticket_activity_log = FactoryBot.create(:ticket_activity_log,
                                               ticket_id: @ticket.id,
                                               user_id: @user.id)

      get :index, params: { user_id: @user.id, ticket_id: @ticket.id }, format: :json
    end

    it 'returns the information about ticket activity logs of a ticket' do
      expect(json_response[:ticket_activity_logs][:data][0][:attributes][:activity]).to eql @ticket_activity_log.activity
    end

    it 'returns the information about assigned user details of activity log' do
      expect(json_response[:ticket_activity_logs][:data][0][:attributes][:user][:data][:id]).to eql @ticket_activity_log.user.id.to_s
    end

    it { is_expected.to respond_with 200 }
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before do
        @ticket_activity_log_attributes = FactoryBot.attributes_for(:ticket_activity_log,
                                                                    ticket_id: @ticket.id,
                                                                    user_id: @user.id)

        post :create, params: { ticket_activity_log: @ticket_activity_log_attributes }
      end

      it 'renders the json representation for the user record just created' do
        expect(json_response[:ticket_activity_log][:data][:attributes][:activity]).to eql @ticket_activity_log_attributes[:activity]
      end

      it { is_expected.to respond_with 201 }
    end

    context 'when is not created' do
      before do
        @invalid_activity_log_attributes = FactoryBot.attributes_for(:ticket_activity_log)
        post :create, params: { ticket_activity_log: @invalid_activity_log_attributes }, format: :json
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        expect(json_response[:errors]).to include 'Ticket must exist'
      end

      it { is_expected.to respond_with 400 }
    end
  end

  describe 'PUT/PATCH #update' do
    before do
      @ticket_activity_log = FactoryBot.create(:ticket_activity_log,
                                               ticket_id: @ticket.id,
                                               user_id: @user.id)
    end

    context 'when is successfully updated' do
      before do
        patch :update, params: { id: @ticket_activity_log.id,
                                 ticket_activity_log: { status: 'completed' } }, format: :json
        @ticket_activity_log.reload
      end

      it 'renders the json representation for the updated user' do
        expect(json_response[:ticket_activity_log][:data][:attributes][:status]).to eql 'completed'
      end

      it { is_expected.to respond_with 200 }
    end

    context 'when is not created' do
      before do
        patch :update, params: { id: @ticket_activity_log.id,
                                 ticket_activity_log: { log_time: nil } }, format: :json
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on whye the user could not be created' do
        expect(json_response[:errors]).to include "Log time can't be blank"
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
        @ticket_activity_log = FactoryBot.create(:ticket_activity_log,
                                                 ticket_id: @ticket.id,
                                                 user_id: @user.id)
      end

      before do
        delete :destroy, params: { id: @ticket_activity_log.id }, format: :json
      end

      it { is_expected.to respond_with 200 }
    end
  end
end
