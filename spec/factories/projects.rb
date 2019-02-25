# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    name { Faker::Lorem.word }
    start_date { '2019-02-24' }
    manager { FactoryBot.create(:user) }
  end
end
