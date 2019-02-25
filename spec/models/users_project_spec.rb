# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersProject, type: :model do
  it { expect(UsersProject.reflect_on_association(:project).macro).to eq(:belongs_to) }
  it { expect(UsersProject.reflect_on_association(:user).macro).to eq(:belongs_to) }
end
