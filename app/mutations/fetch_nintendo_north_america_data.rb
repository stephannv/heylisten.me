class FetchNintendoNorthAmericaData < Mutations::Command
  def execute
    fetch_all_data
  end

  private def fetch_all_data
    all_data = NintendoNorthAmericaClient::PRICES_FILTERS.map do |price_filter|
      fetch_data(price_filter: price_filter)
    end

    all_data.reduce(&:+).uniq { |d| d['objectID'] }
  end

  private def fetch_data(price_filter:)
    data = client.fetch(index: client.index_desc, price_filter: price_filter)
    data += client.fetch(index: client.index_asc, price_filter: price_filter) if data.size >= 1000
    data
  end

  private def client
    @client ||= NintendoNorthAmericaClient.new
  end
end
