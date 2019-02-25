# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    name { 'MyString' }
    start_date { '2019-02-24' }
    manager_id { nil }
  end
end
