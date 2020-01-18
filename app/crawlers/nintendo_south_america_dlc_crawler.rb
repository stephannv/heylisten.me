class NintendoSouthAmericaDlcCrawler
  def crawl_dlc(item:)
    page = fetch_page(item.website_url)

    crawl_data(page: page, item: item)
  end

  private def fetch_page(website_url)
    Nokogiri::HTML(Down.download(website_url))
  end

  # rubocop:disable Metrics/MethodLength
  private def crawl_data(page:, item:)
    page.css('.product-options-item').map do |el|
      {
        data_source: item.data_source,
        item_type: :dlc,
        identifier: crawl_identifier(el),
        nsuid: '',
        title: crawl_title(el),
        released_at: '',
        pretty_release_date: '',
        image_url: item.image_url,
        website_url: item.website_url,
        data: { empty: true }
      }
    end
  end
  # rubocop:enable Metrics/MethodLength

  private def crawl_identifier(element)
    element.css('.product-options-item-price .price-box').first['data-product-id'.to_sym]
  end

  private def crawl_title(element)
    element.css('.product-options-item-title a').first.content.strip
  end
end
