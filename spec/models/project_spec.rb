# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  context '#associations' do
    it { expect(Project.reflect_on_association(:manager).macro).to eq(:belongs_to) }
    it { expect(Project.reflect_on_association(:users).macro).to eq(:has_many) }
  end

  context '#validations' do
    before do
      manager = FactoryBot.create(:user)
      @project = FactoryBot.create(:project, manager: manager)
    end

    subject { @project }

    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
