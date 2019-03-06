# frozen_string_literal: true

FactoryBot.define do
  factory :ticket_activity_log do
    ticket { nil }
    user { nil }
    log_time { 1.5 }
    log_date { '2019-03-06' }
    activity { Faker::Lorem.word }
    approved_by { 1 }
    status { 'MyString' }
  end
end
