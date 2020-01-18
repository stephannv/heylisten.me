require 'rails_helper'

RSpec.describe NintendoSouthAmericaCrawler, type: :crawler do
  describe 'Constants' do
    it 'has SOUTH_AMERICA_STORE_URLS constant' do
      expect(described_class::SOUTH_AMERICA_STORE_URLS).to eq(brasil: 'https://store.nintendo.com.br')
    end
  end

  describe 'Instance methods' do
    describe '#crawl' do
      let(:page) { double }
      let(:data) { double }
      before do
        allow(subject).to receive(:fetch_page).with(country: :brasil).and_return(page)
        allow(subject).to receive(:crawl_data).with(page: page, country: :brasil).and_return(data)
      end

      it 'fetches data from Brasil store' do
        expect(subject.crawl).to eq data
      end
    end
  end

  describe 'Private methods' do
    describe '#fetch_page' do
      let(:file) { double }
      let(:page) { double }
      let(:country) { :brasil }
      before do
        allow(Down).to receive(:download).with(described_class::SOUTH_AMERICA_STORE_URLS[country]).and_return(file)
        allow(Nokogiri).to receive(:HTML).with(file).and_return(page)
      end

      it 'downloads the store html page' do
        expect(subject.send(:fetch_page, country: country)).to eq page
      end
    end

    describe '#crawl_data' do
      let(:page) { double }
      let(:el) { double }
      let(:country) { :brasil }

      before do
        allow(page).to receive(:css).with('div.category-product-item').and_return([el])
        allow(subject).to receive(:crawl_identifier).with(el).and_return('123')
        allow(subject).to receive(:crawl_title).with(el).and_return('My Game')
        allow(subject).to receive(:crawl_release_date).with(el).and_return('01/01/2020')
        allow(subject).to receive(:crawl_image).with(el).and_return('https://example.com/image.png')
        allow(subject).to receive(:crawl_website_url).with(el).and_return('https://example.com')
      end

      it 'extracts game data from given page' do
        data = subject.send(:crawl_data, page: page, country: country)
        expected_data = [{
          data_source: :nintendo_brasil,
          item_type: :game,
          identifier: '123',
          nsuid: '',
          title: 'My Game',
          released_at: DateTime.parse('01/01/2020'),
          pretty_release_date: '01/01/2020',
          image_url: 'https://example.com/image.png',
          website_url: 'https://example.com',
          data: { empty: true }
        }]

        expect(data).to eq expected_data
      end
    end

    describe '#crawl_identifier' do
      let(:el) { double }

      before do
        allow(el).to receive(:css)
          .with('div.category-product-item-title div.price-box')
          .and_return([{ 'data-product-id'.to_sym => '123' }])
      end

      it 'returns identifier' do
        expect(subject.send(:crawl_identifier, el)).to eq '123'
      end
    end

    describe '#crawl_title' do
      let(:el) { double }

      before do
        allow(el).to receive(:css)
          .with('div.category-product-item-title a')
          .and_return([double(content: ' My Game      ')])
      end

      it 'returns title' do
        expect(subject.send(:crawl_title, el)).to eq 'My Game'
      end
    end

    describe '#crawl_website_url' do
      let(:el) { double }

      before do
        allow(el).to receive(:css)
          .with('div.category-product-item-title a')
          .and_return([{ href: 'example.com' }])
      end

      it 'returns website url' do
        expect(subject.send(:crawl_website_url, el)).to eq 'example.com'
      end
    end

    describe '#crawl_image' do
      let(:el) { double }

      before do
        allow(el).to receive(:css)
          .with('div.category-product-item-img a.photo span span img')
          .and_return([{ src: 'example.com/image.png' }])
      end

      it 'returns image' do
        expect(subject.send(:crawl_image, el)).to eq 'example.com/image.png'
      end
    end

    describe '#crawl_release_date' do
      let(:el) { double }

      before do
        allow(el).to receive(:css)
          .with('div.category-product-item-released')
          .and_return([double(content: 'Lançado em 01/01/2020')])
      end

      it 'returns release date' do
        expect(subject.send(:crawl_release_date, el)).to eq '01/01/2020'
      end
    end
  end
end
