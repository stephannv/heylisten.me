class NintendoAlgoliaClient
  def initialize
    @client = Algolia::Search::Client.create("U3B6GR4UA3", "a29c6927638bfd8cee23993e51e721c9")
  end

  def fetch(index:, query:)
    response = index.search(query, queryType: 'prefixAll', hitsPerPage: 1000, filters: 'corePlatforms:"Nintendo Switch"')
    response.with_indifferent_access[:hits].to_a
  end

  def index_asc
    @index_asc ||= @client.init_index('store_game_en_us_title_asc')
  end

  def index_desc
    @index_desc ||= @client.init_index('store_game_en_us_title_des')
  end

  def index_br_asc
    @index_br_asc ||= @client.init_index('ncom_game_pt_br_title_asc')
  end

  def index_br_desc
    @index_br_desc ||= @client.init_index('ncom_game_pt_br_title_des')
  end
end
