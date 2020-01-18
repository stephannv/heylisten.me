require 'rails_helper'

RSpec.describe NintendoSouthAmericaDlcCrawler, type: :crawler do
  describe 'Instance methods' do
    describe '#crawl_dlc' do
      let(:item) { double(website_url: 'example.com') }
      let(:page) { double }
      let(:data) { double }

      before do
        allow(subject).to receive(:fetch_page).with('example.com').and_return(page)
        allow(subject).to receive(:crawl_data).with(page: page, item: item).and_return(data)
      end

      it 'fetches data given item store page' do
        expect(subject.crawl_dlc(item: item)).to eq data
      end
    end
  end

  describe 'Private methods' do
    describe '#fetch_page' do
      let(:file) { double }
      let(:page) { double }
      let(:website_url) { 'example.com' }
      before do
        allow(Down).to receive(:download).with(website_url).and_return(file)
        allow(Nokogiri).to receive(:HTML).with(file).and_return(page)
      end

      it 'downloads the item store html page' do
        expect(subject.send(:fetch_page, website_url)).to eq page
      end
    end

    describe '#crawl_data' do
      let(:page) { double }
      let(:el) { double }
      let(:item) { build(:item) }

      before do
        allow(page).to receive(:css).with('.product-options-item').and_return([el])
        allow(subject).to receive(:crawl_identifier).with(el).and_return('123')
        allow(subject).to receive(:crawl_title).with(el).and_return('My DLC')
      end

      it 'extracts game data from given page' do
        data = subject.send(:crawl_data, page: page, item: item)
        expected_data = [{
          data_source: item.data_source,
          item_type: :dlc,
          identifier: '123',
          nsuid: '',
          title: 'My DLC',
          released_at: '',
          pretty_release_date: '',
          image_url: item.image_url,
          website_url: item.website_url,
          data: { empty: true }
        }]

        expect(data).to eq expected_data
      end
    end

    describe '#crawl_identifier' do
      let(:el) { double }

      before do
        allow(el).to receive(:css)
          .with('.product-options-item-price .price-box')
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
          .with('.product-options-item-title a')
          .and_return([double(content: ' My DLC      ')])
      end

      it 'returns title' do
        expect(subject.send(:crawl_title, el)).to eq 'My DLC'
      end
    end
  end
end
