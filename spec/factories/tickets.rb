# frozen_string_literal: true

FactoryBot.define do
  factory :ticket do
    title { 'MyString' }
    description { 'MyText' }
    project { nil }
    status { 'MyString' }
    maximum_permitted_time { 1 }
    created_user_id { 1 }
    category { 'MyString' }
    start_date { '2019-03-02' }
    end_date { '2019-03-02' }
  end
end
