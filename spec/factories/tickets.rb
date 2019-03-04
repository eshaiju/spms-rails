# frozen_string_literal: true

FactoryBot.define do
  factory :ticket do
    title { Faker::Lorem.word }
    description { 'MyText' }
    project { nil }
    status { 'MyString' }
    maximum_permitted_time { 1 }
    category { 'MyString' }
    start_date { '2019-03-02' }
    end_date { '2019-03-02' }
  end
end
