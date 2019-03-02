# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::TicketsController do
  describe 'GET #index' do
    before do
      user = FactoryBot.create(:user)
      user.confirm
      api_authorization_header JsonWebToken.encode(user_id: user.id)
      project = FactoryBot.create(:project)
      @ticket = FactoryBot.create(:ticket,
                                  created_user: user,
                                  assigned_user_id: user.id,
                                  project_id: project.id)
      get :index, params: { assigned_user_id: user.id, project_id: project.id }, format: :json
    end

    it 'returns the information about tickets of a project' do
      expect(json_response[:tickets][:data][0][:attributes][:title]).to eql @ticket.title
    end

    it 'returns the information about assigned user details of ticket' do
      expect(json_response[:tickets][:data][0][:attributes][:assigned_user][:data][:id]).to eql @ticket.assigned_user.id.to_s
    end

    it { is_expected.to respond_with 200 }
  end
end
