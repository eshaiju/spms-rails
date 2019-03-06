# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context '#associations' do
    it { expect(User.reflect_on_association(:projects).macro).to eq(:has_many) }
    it { expect(User.reflect_on_association(:managed_projects).macro).to eq(:has_many) }
    it { expect(User.reflect_on_association(:tickets).macro).to eq(:has_many) }
    it { expect(User.reflect_on_association(:ticket_activity_logs).macro).to eq(:has_many) }
  end

  context '#validations' do
    before { @user = FactoryBot.build(:user) }

    subject { @user }

    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
  end

  context '#methods' do
    it 'returns designations' do
      expect(User.designations).to eq ({
        developer: 'Developer',
        qa: 'QA',
        manager: 'Manager'
      })
    end

    it 'return full name' do
      user = FactoryBot.build(:user)
      expect(user.name).to eq "#{user.first_name} #{user.last_name}"
    end

    it 'downcase_email' do
      user = FactoryBot.create(:user, email: 'Email@example.com ')
      expect(user.email).to eq 'email@example.com'
    end
  end
end
