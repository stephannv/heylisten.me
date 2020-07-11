class NintendoNorthAmericaDataAdapter
  def initialize(data:)
    @data = data
  end

  # rubocop:disable Metrics/MethodLength
  def adapt
    {
      data_source: data_source,
      item_type: data_type,
      identifier: identifier,
      nsuid: nsuid,
      title: title,
      released_at: released_at,
      pretty_release_date: pretty_release_date,
      image_url: image_url,
      website_url: website_url,
      data: @data.except('_highlightResult')
    }
  end
  # rubocop:enable Metrics/MethodLength

  private def data_source
    :nintendo_america
  end

  private def data_type
    :game
  end

  private def identifier
    @data['objectID']
  end

  private def nsuid
    @data['nsuid']
  end

  private def title
    @data['title']
  end

  private def released_at
    @data['releaseDateDisplay'].to_date
  rescue StandardError
    '31/12/2050'.to_date
  end

  private def pretty_release_date
    @data['releaseDateDisplay'].to_date.to_s
  rescue StandardError
    @data['releaseDateDisplay']
  end

  private def image_url
    "https://www.nintendo.com#{@data['boxart']}"
  end

  private def website_url
    "https://www.nintendo.com#{@data['url']}"
  end
end
