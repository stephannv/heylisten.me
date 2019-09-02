FactoryBot.define do
  factory :event do
    item
    event_type { Event.event_types.values.sample }

    after :build do |event|
      event.data = event.item.attributes
    end
  end
end
