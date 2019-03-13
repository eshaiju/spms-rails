# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::TicketActivityLogsController do
  before do
    @user = FactoryBot.create(:user)
    @user.confirm
    api_authorization_header JsonWebToken.encode(user_id: @user.id)
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before do
        project = FactoryBot.create(:project, manager: @user)
        ticket = FactoryBot.create(:ticket,
                                   project: project,
                                   created_user: @user)
        @ticket_activity_log_attributes = FactoryBot.attributes_for(:ticket_activity_log,
                                                                    ticket_id: ticket.id,
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
      project = FactoryBot.create(:project, manager: @user)
      ticket = FactoryBot.create(:ticket,
                                 project: project,
                                 created_user: @user)
      @ticket_activity_log = FactoryBot.create(:ticket_activity_log,
                                               ticket_id: ticket.id,
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
end
