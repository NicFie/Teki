FactoryBot.define do
  factory :invitations do
    user
    user_id { 1 }
    friend_id { 2 }
  end
end
