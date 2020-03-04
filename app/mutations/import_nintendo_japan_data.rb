class ImportNintendoJapanData < Mutations::Command
  def execute
    fetch_data
    parse_data
    import_data
  end

  private def fetch_data
    @data_collection = FetchNintendoJapanData.run!
  end

  private def parse_data
    @parsed_data_collection = @data_collection.map do |data|
      NintendoJapanDataAdapter.new(data: data).adapt
    end
  end

  private def import_data
    @parsed_data_collection.each do |data|
      item = Item.find_or_initialize_by(data_source_cd: data[:data_source], identifier: data[:identifier])
      item.assign_attributes(data)
      item.save!
    rescue StandardError => e
      Rails.logger.error(e.full_message)
    end
  end
end
