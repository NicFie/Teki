# frozen_string_literal: true

FactoryBot.define do
  factory :friendship do
    status { true }
    association :asker, factory: :user
    association :receiver, factory: :user
  end
end
