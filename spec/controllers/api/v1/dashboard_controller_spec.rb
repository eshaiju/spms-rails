# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::DashboardController do
  describe 'GET #index' do
    before do
      user = FactoryBot.create(:user)
      user.confirm
      api_authorization_header JsonWebToken.encode(user_id: user.id)
      @project = FactoryBot.create(:project)
      FactoryBot.create(:users_project, user_id: user.id, project_id: @project.id)
      @ticket = FactoryBot.create(:ticket,
                                  created_user: user,
                                  assigned_user_id: user.id,
                                  project_id: @project.id,
                                  start_date: Time.zone.now)

      @ticket_old = FactoryBot.create(:ticket,
                                      created_user: user,
                                      assigned_user_id: user.id,
                                      project_id: @project.id,
                                      start_date: Time.zone.now - 1.day)
      get :index, params: { start_date: Time.zone.now }, format: :json
    end

    context 'with start date' do
      before do
        get :index, params: {}, format: :json
      end

      it 'returns the information about tickets of current user' do
        expect(json_response[:dashboard][:data][:attributes][:tickets][:data][0][:attributes][:title]).to eql @ticket.title
      end

      it 'returns all tickets of current user' do
        expect(json_response[:dashboard][:data][:attributes][:tickets][:data].count).to eql Ticket.count
      end
    end

    context 'with start date' do
      before do
        get :index, params: { start_date: Time.zone.now }, format: :json
      end

      it 'returns the information about tickets of current user from start date' do
        expect(json_response[:dashboard][:data][:attributes][:tickets][:data][0][:attributes][:title]).to eql @ticket.title
      end

      it 'returns tickets from start date current user' do
        expect(json_response[:dashboard][:data][:attributes][:tickets][:data].count).to eql Ticket.count - 1
      end
    end

    it 'returns all assigned projects name and ID' do
      expect(json_response[:dashboard][:data][:attributes][:projects][:data][0][:id]).to eql @project.id.to_s
    end

    it { is_expected.to respond_with 200 }
  end
end
