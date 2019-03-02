# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::UsersProjectsController do
  describe 'GET #my_projects' do
    before do
      @user = FactoryBot.create(:user)
      @user.confirm
      api_authorization_header JsonWebToken.encode(user_id: @user.id)
      @project = FactoryBot.create(:project)
      @users_project = FactoryBot.create(:users_project, user_id: @user.id, project_id: @project.id)
      get :my_projects, format: :json
    end

    it 'returns the information about current user projects' do
      expect(json_response[:data][0][:attributes][:name]).to eql @project.name
    end

    it 'returns the information about manager details of projects' do
      expect(json_response[:data][0][:attributes][:manager][:data][:id]).to eql @project.manager.id.to_s
    end

    it { is_expected.to respond_with 200 }
  end
end
