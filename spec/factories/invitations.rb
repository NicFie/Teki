FactoryBot.define do
  factory :invitation do
    association :user
    friend_id { 2 }
    confirmed { false }
  end
end
