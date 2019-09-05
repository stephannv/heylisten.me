class NintendoNorthAmericaClient
  PRICES_FILTERS = [
    nil,
    'priceRange:"Free to start"',
    'priceRange:"$0 - $4.99"',
    'priceRange:"$5 - $9.99"',
    'priceRange:"$10 - $19.99"',
    'priceRange:"$20 - $39.99"',
    'priceRange:"$40+"'
  ].freeze

  def fetch(index:, price_filter:)
    filters = build_filters(price_filter)
    response = index.search('', hitsPerPage: 1000, filters: filters)
    response['hits'].to_a
  end

  def index_desc
    @index_desc ||= Algolia::Index.new('noa_aem_game_en_us_release_des')
  end

  def index_asc
    @index_asc ||= Algolia::Index.new('noa_aem_game_en_us_release_asc')
  end

  private def build_filters(price_filter)
    ['platform:"Nintendo Switch"', price_filter].compact.join(' AND ')
  end
end
