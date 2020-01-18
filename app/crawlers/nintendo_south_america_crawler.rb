class NintendoSouthAmericaCrawler
  SOUTH_AMERICA_STORE_URLS = {
    brasil: 'https://store.nintendo.com.br'
  }.freeze

  def crawl(country: :brasil)
    page = fetch_page(country: country)

    crawl_data(page: page, country: country)
  end

  private def fetch_page(country:)
    Nokogiri::HTML(Down.download(SOUTH_AMERICA_STORE_URLS[country]))
  end

  # rubocop:disable Metrics/MethodLength
  private def crawl_data(page:, country:)
    page.css('div.category-product-item').map do |el|
      {
        data_source: "nintendo_#{country}".to_sym,
        item_type: :game,
        identifier: crawl_identifier(el),
        nsuid: '',
        title: crawl_title(el),
        released_at: crawl_release_date(el).to_datetime,
        pretty_release_date: crawl_release_date(el),
        image_url: crawl_image(el),
        website_url: crawl_website_url(el),
        data: {
          is_dlc_available: crawl_dlc_availability(el)
        }
      }
    end
  end
  # rubocop:enable Metrics/MethodLength

  private def crawl_identifier(element)
    element.css('div.category-product-item-title div.price-box').first[:'data-product-id']
  end

  private def crawl_title(element)
    element.css('div.category-product-item-title a').first.content.strip
  end

  private def crawl_website_url(element)
    element.css('div.category-product-item-title a').first[:href]
  end

  private def crawl_image(element)
    element.css('div.category-product-item-img a.photo span span img').first[:src]
  end

  private def crawl_release_date(element)
    element.css('div.category-product-item-released').first.content.strip[-10..-1]
  end

  private def crawl_dlc_availability(element)
    element.css('.category-product-item-img .category-product-item-labels .label.dlc').present?
  end
end
