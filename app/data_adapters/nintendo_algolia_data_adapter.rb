class NintendoAlgoliaDataAdapter
  def initialize(data:, data_source:)
    @data = data
    @data_source = data_source
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
    @data_source
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
    url = @data['boxart']
    return banner_picture_url || "https://via.placeholder.com/540x360?text=No%20image" if url.blank?
    url = "https://www.nintendo.com#{url}" unless url.start_with?('http')
    url
  end

  def banner_picture_url
    return if @data['horizontalHeaderImage'].blank?

    url = @data['horizontalHeaderImage']
    url = "https://www.nintendo.com#{url}" unless url.start_with?('http')
    url
  end

  private def website_url
    "https://www.nintendo.com#{@data['url']}"
  end
end
