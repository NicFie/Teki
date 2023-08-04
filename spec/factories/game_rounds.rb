FactoryBot.define do
  factory :game_round do
    completion_time { Time.now }
    association :game
    association :winner, factory: :user
    association :challenge
  end
end
