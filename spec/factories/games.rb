FactoryBot.define do
  factory :game do
    association :player_one, factory: :user
    association :player_two, factory: :user
    game_winner { 1 }
    round_count { 3 }
    winner_score { 2 }
    loser_score { 1 }
    with_friend { true }
    # association :league
  end
end
