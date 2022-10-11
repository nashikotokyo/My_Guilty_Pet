FactoryBot.define do
  factory :comment do
    body { Faker::Quote.yoda }
    user
    post
  end
end