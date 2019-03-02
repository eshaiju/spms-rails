# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ticket, type: :model do
  context '#associations' do
    it { expect(Ticket.reflect_on_association(:project).macro).to eq(:belongs_to) }
    it { expect(Ticket.reflect_on_association(:created_user).macro).to eq(:belongs_to) }
    it { expect(Ticket.reflect_on_association(:assigned_user).macro).to eq(:belongs_to) }
  end

  context '#validations' do
    subject { @ticket }

    before do
      manager = FactoryBot.create(:user)
      project = FactoryBot.create(:project, manager: manager)
      @ticket = FactoryBot.create(:ticket,
                                  project: project,
                                  created_user: manager)
    end

    it { is_expected.to validate_uniqueness_of(:title) }
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:category) }
  end

  context '#methods' do
    it 'returns categories' do
      expect(Ticket.categories).to eq ({
        feature: 'Feature',
        bug: 'Bug',
        chore: 'Chore',
        support: 'Support'
      })
    end

    it 'returns states' do
      expect(Ticket.states).to eq ({
        idea: 'Idea',
        defined: 'Defined',
        in_progress: 'In-Progress',
        completed: 'Completed',
        accepted: 'Accepted',
        released: 'Released'
      })
    end
  end
end
