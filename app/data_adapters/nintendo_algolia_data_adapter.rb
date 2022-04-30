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
    case @data['dlcType']
    when "Individual"
      :dlc
    when "Bundle"
      :dlc
    when "ROM Bundle"
      :bundle
    else
      :game
    end
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

  private def image_url
    url = @data['productImage']
    return "https://via.placeholder.com/540x360?text=No%20image" if url.blank?
    url = "https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_auto/c_scale,w_300/v1/#{url}" unless url.start_with?('http')
    url
  end

  private def website_url
    "https://www.nintendo.com#{@data['url']}"
  end
end
