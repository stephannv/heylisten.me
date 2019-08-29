FactoryBot.define do
  factory :event do
    item
    event_type { Event.event_types.values.sample }
    data { { key: 'value' } }
  end
end
