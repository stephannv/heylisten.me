class NintendoEuropeClient
  include HTTParty

  base_uri 'https://searching.nintendo-europe.com/en'
  default_params q: '*', sort: 'date_from desc'

  def fetch(offset:, limit:, data_type:)
    query_params = { start: offset, rows: limit }.merge(build_fq_param(data_type))
    result = self.class.get('/select', query: query_params)
    result.parsed_response.with_indifferent_access
  end

  private def build_fq_param(data_type)
    case data_type
    when 'game'
      { fq: 'type:GAME AND playable_on_txt:"HAC"' }
    when 'dlc'
      { fq: 'type:DLC' }
    else
      raise 'NOT SUPPORTED TYPE'
    end
  end
end
