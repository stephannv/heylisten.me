FactoryBot.define do
  factory :dispatch do
    event
    situation { Dispatch.situations.values.sample }
  end
end
