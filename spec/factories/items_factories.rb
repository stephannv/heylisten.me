FactoryBot.define do
  factory :item do
    data_source { Item.data_sources.keys.sample }
    item_type { Item.item_types.keys.sample }
    identifier { Faker::Crypto.md5 }
    nsuid { Faker::Crypto.md5 }
    title { "Pokemon: Let`s Go #{Faker::Games::Pokemon.name}" }
    released_at { Faker::Date.between(from: Time.zone.today, to: 7.days.from_now) }
    pretty_release_date { Faker::Lorem.word }
    image_url { Faker::Avatar.image }
    website_url { Faker::Internet.url }
    data { { 'some_data' => 'some data' } }
  end
end
