# frozen_string_literal: true

FactoryBot.define do
  factory :game_round do
    completion_time { Time.zone.now }
    association :game
    association :winner, factory: :user
    association :challenge
  end
end
