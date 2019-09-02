class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include SimpleEnum::Mongoid

  belongs_to :item

  embeds_many :dispatches

  as_enum :event_type, %i[item_added item_changed], map: :string, field: { type: String }

  field :message, type: String
  field :data, type: Hash

  index(item_id: 1)
  index(event_type_cd: 1)
  index(created_at: -1)

  validates :item_id, presence: true
  validates :event_type_cd, presence: true
  validates :data, presence: true
  validates :message, presence: true

  before_validation :set_message
  after_create :register_dispatches

  private def set_message
    self.message = BuildEventMessage.run!(event: self)
  end

  private def register_dispatches
    dispatches.create!(situation: :pending)
  end
end
