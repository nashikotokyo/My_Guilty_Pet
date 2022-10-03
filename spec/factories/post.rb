FactoryBot.define do
  factory :post do
    body { Faker::Hacker.say_something_smart }
    image { [File.open("#{Rails.root}/spec/fixtures/fixture.png")] }
    user
  end
end