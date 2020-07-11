FactoryBot.define do
  factory :dispatch do
    event
    situation { Dispatch.situations.values.sample }
    target { Dispatch.targets.values.sample }
  end
end
