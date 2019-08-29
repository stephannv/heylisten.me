class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include SimpleEnum::Mongoid

  belongs_to :item

  as_enum :event_type, %i[item_added item_changed], map: :string, field: { type: String }

  field :data, type: Hash

  index(item_id: 1)
  index(event_type_cd: 1)
  index(created_at: -1)

  validates :item_id, presence: true
  validates :event_type_cd, presence: true
  validates :data, presence: true
end
