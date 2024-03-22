# frozen_string_literal: true

FactoryBot.define do
  factory :game_round do
    completion_time { Time.zone.now }
    game
    winner factory: %i[user]
    challenge
  end
end
