class FetchNintendoEuropeData < Mutations::Command
  required do
    string :data_type, in: %w[game dlc]
  end

  def execute
    fetch_all_data
  end

  private def fetch_all_data
    all_data = []

    (1..).each do |page|
      data = fetch_data(page: page)

      break if data.blank?

      all_data += data
    end

    all_data
  end

  private def fetch_data(page:)
    limit = 1000
    offset = limit * (page - 1)
    response = client.fetch(limit: limit, offset: offset, data_type: data_type)
    response.dig(:response, :docs)
  end

  private def client
    @client ||= NintendoEuropeClient.new
  end
end
