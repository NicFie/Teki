FactoryBot.define do
  factory :user do
    username { "Billy" }
    email { "billybob@gmail.com" }
    password { "123456" }
    admin { false }
  end
end
