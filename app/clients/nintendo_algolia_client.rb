class NintendoAlgoliaClient
  def fetch(index:, query:)
    response = index.search(query, queryType: 'prefixAll', hitsPerPage: 1000, filters: 'corePlatforms:"Nintendo Switch"')
    response.with_indifferent_access[:hits].to_a
  end

  def index_asc
    @index_asc ||= Algolia::Index.new('store_game_en_us_title_asc')
  end

  def index_desc
    @index_desc ||= Algolia::Index.new('store_game_en_us_title_des')
  end

  def index_br_asc
    @index_br_asc ||= Algolia::Index.new('ncom_game_pt_br_title_asc')
  end

  def index_br_desc
    @index_br_desc ||= Algolia::Index.new('ncom_game_pt_br_title_des')
  end
end
