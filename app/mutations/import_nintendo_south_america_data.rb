class ImportNintendoSouthAmericaData < Mutations::Command
  def execute
    fetch_data
    import_data
  end

  private def fetch_data
    @data_collection = crawler.crawl
  end

  private def import_data
    @data_collection.each do |data|
      item = Item.find_or_initialize_by(data_source_cd: data[:data_source], identifier: data[:identifier])
      item.assign_attributes(data)
      item.save!
    rescue StandardError => e
      Rails.logger.error(e.full_message)
    end
  end

  private def crawler
    @crawler ||= NintendoSouthAmericaCrawler.new
  end
end
