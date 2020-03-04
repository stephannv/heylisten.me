class FetchNintendoJapanData < Mutations::Command
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
    limit = 300
    response = client.fetch(limit: limit, page: page)
    response.dig(:result, :items)
  end

  private def client
    @client ||= NintendoJapanClient.new
  end
end
