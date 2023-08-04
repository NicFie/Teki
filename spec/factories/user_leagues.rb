FactoryBot.define do
  factory :user_league do
    association :user
    association :league
  end
end
