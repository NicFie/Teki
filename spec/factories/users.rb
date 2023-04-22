FactoryBot.define do
  factory :user do
    username { "Nicola" }
    email { "nicola@mail.com" }
    password { "123456" }
    admin { false }
    updated_at { 2.minutes.ago }
  end
end
