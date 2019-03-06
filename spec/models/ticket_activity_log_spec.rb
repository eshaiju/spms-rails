# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TicketActivityLog, type: :model do
  context '#associations' do
    it { expect(TicketActivityLog.reflect_on_association(:ticket).macro).to eq(:belongs_to) }
    it { expect(TicketActivityLog.reflect_on_association(:user).macro).to eq(:belongs_to) }
  end

  context '#validations' do
    subject { @activity }

    before do
      user = FactoryBot.create(:user)
      project = FactoryBot.create(:project, manager: user)
      ticket = FactoryBot.create(:ticket,
                                 project: project,
                                 created_user: user)
      @activity = FactoryBot.create(:ticket_activity_log,
                                    ticket: ticket,
                                    user: user)
    end

    it { is_expected.to validate_presence_of(:activity) }
    it { is_expected.to validate_presence_of(:log_date) }
    it { is_expected.to validate_presence_of(:log_time) }
  end
end
