class FetchNintendoNorthAmericaData < Mutations::Command
  def execute
    fetch_all_data
  end

  private def fetch_all_data
    puts "== Importing North America data =="
    all_data = queries.flat_map do |query|
      puts "> querying with #{query}"
      fetch_data(query: query)
    end

    all_data.uniq { |d| d[:objectID] }
  end

  private def queries
    ('a'..'z').to_a + ('0'..'9').to_a
  end

  private def fetch_data(query:)
    puts "query asc"
    data = client.fetch(index: client.index_asc, query: query)
    puts "query desc"
    data += client.fetch(index: client.index_desc, query: query) if data.size >= 1000
    data
  end

  private def client
    @client ||= NintendoAlgoliaClient.new
  end
end
