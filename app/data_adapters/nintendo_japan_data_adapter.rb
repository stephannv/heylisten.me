class NintendoJapanDataAdapter
  def initialize(data:)
    @data = data
  end

  # rubocop:disable Metrics/MethodLength
  def adapt
    {
      data_source: data_source,
      item_type: item_type,
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
    :nintendo_japan
  end

  private def item_type
    case @data[:sform].to_s.downcase
    when 'dl_soft', 'hac_downloadable', 'hac_dl', 'hac_card'
      :game
    when 'dl_dlc', 'dlc'
      :dlc
    end
  end

  private def identifier
    @data[:id]
  end

  private def nsuid
    @data[:nsuid]
  end

  private def title
    @data[:title]
  end

  private def released_at
    @data[:dsdate].try(:to_date) || @data[:sdate].try(:to_date)
  end

  private def pretty_release_date
    @data[:sdate]
  end

  private def image_url
    "https://img-eshop.cdn.nintendo.net/i/#{@data[:iurl]}.jpg?w=560&h=316"
  end

  private def website_url
    if item_type == :game
      @data[:url] || "https://ec.nintendo.com/JP/ja/titles/#{@data[:nsuid]}"
    else
      'NO WEBSITE'
    end
  end
end
