class NintendoEuropeDataAdapter
  def initialize(data:, item_type:)
    @data = data
    @item_type = item_type
  end

  # rubocop:disable Metrics/MethodLength
  def adapt
    {
      data_source: data_source,
      item_type: @item_type,
      identifier: identifier,
      nsuid: nsuid,
      title: title,
      released_at: released_at,
      pretty_release_date: pretty_release_date,
      image_url: image_url,
      website_url: website_url,
      data: @data
    }
  end
  # rubocop:enable Metrics/MethodLength

  private def data_source
    :nintendo_europe
  end

  private def identifier
    @data[:fs_id]
  end

  private def nsuid
    @data[:nsuid_txt].try(:first)
  end

  private def title
    @data[:title]
  end

  private def released_at
    @data[:dates_released_dts].map(&:to_date).min
  rescue StandardError
    @data[:date_from]
  end

  private def pretty_release_date
    @data[:pretty_date_s]
  end

  private def image_url
    url = @data[:image_url_sq_s] || @data[:image_url]
    url = "https:#{url}" if url.start_with?('//')
    url
  end

  private def website_url
    "https://www.nintendo.co.uk#{@data[:url]}"
  end
end
