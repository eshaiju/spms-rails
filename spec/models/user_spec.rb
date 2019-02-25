# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context '#associations' do
    it { expect(User.reflect_on_association(:projects).macro).to eq(:has_many) }
    it { expect(User.reflect_on_association(:managed_projects).macro).to eq(:has_many) }
  end

  context '#validations' do
    before { @user = FactoryBot.build(:user) }

    subject { @user }

    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
  end
end
