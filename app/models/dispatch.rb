class Dispatch
  include Mongoid::Document
  include Mongoid::Timestamps
  include SimpleEnum::Mongoid

  embedded_in :event

  as_enum :situation, %i[pending done failed], map: :string, field: { type: String }
  as_enum :target, %i[twitter discord], map: :string, field: { type: String }

  field :message, type: String

  validates :situation_cd, presence: true
  validates :target_cd, presence: true
end
