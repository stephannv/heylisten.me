FactoryBot.define do
  factory :task do
    name { Faker::Lorem.word }
    status { Faker::Lorem.word }
    message { Faker::Lorem.word }
  end
end
