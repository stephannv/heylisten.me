class Item
  include Mongoid::Document
  include Mongoid::Timestamps
  include SimpleEnum::Mongoid

  #################
  ### RELATIONS ###
  #################
  has_many :events, dependent: :destroy

  ##############
  ### FIELDS ###
  ##############
  as_enum :item_type, %i[game dlc bundle subscription ticket], map: :string, field: { type: String }
  as_enum :data_source, %i[nintendo_europe nintendo_america], map: :string, field: { type: String }

  field :identifier, type: String
  field :nsuid, type: String
  field :title, type: String
  field :released_at, type: DateTime
  field :pretty_release_date, type: String
  field :image_url, type: String
  field :website_url, type: String
  field :data, type: Hash

  ###############
  ### INDEXES ###
  ###############
  index({ data_source_cd: 1, identifier: 1 }, unique: true)
  index(title: 1)
  index(released_at: -1)

  ###################
  ### VALIDATIONS ###
  ###################
  validates :identifier, presence: true
  validates :title, presence: true
  validates :image_url, presence: true
  validates :website_url, presence: true
  validates :data, presence: true
  validates :item_type_cd, presence: true
  validates :data_source_cd, presence: true

  validates :identifier, uniqueness: { scope: :data_source_cd }

  validates :identifier, length: { maximum: 255 }
  validates :title, length: { maximum: 255 }
  validates :pretty_release_date, length: { maximum: 32 }
  validates :image_url, length: { maximum: 255 }
  validates :website_url, length: { maximum: 255 }

  #################
  ### CALLBACKS ###
  #################
  after_save :create_event

  ################################
  ### PRIVATE INSTANCE METHODS ###
  ################################
  private def create_event
    CreateEvent.run!(item: self)
  end
end
