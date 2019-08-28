require 'rails_helper'

describe NintendoEuropeDataAdapter, type: :data_adapters do
  describe 'Adapted fields' do
    let(:item_type) { Item.item_types.values.sample }
    let(:data) { {} }

    context 'adapting data_source' do
      subject { described_class.new(data: data, item_type: item_type).adapt }

      it 'returns :nintendo_europe' do
        expect(subject[:data_source]).to eq :nintendo_europe
      end
    end

    context 'adapting item_type' do
      subject { described_class.new(data: data, item_type: item_type).adapt }

      it 'returns @item_type' do
        expect(subject[:item_type]).to eq item_type
      end
    end

    context 'adapting nsuid' do
      subject { described_class.new(data: data, item_type: item_type).adapt }

      context 'when nsuid is blank' do
        let(:data) { { nsuid_txt: nil } }

        it 'returns nil' do
          expect(subject[:nsuid]).to be_nil
        end
      end

      context 'when nsuid is present' do
        let(:data) { { nsuid_txt: [Faker::Lorem.word] } }

        it 'returns first item on nsuid_txt array' do
          expect(subject[:nsuid]).to eq data[:nsuid_txt].first
        end
      end
    end

    context 'adapting title' do
      subject { described_class.new(data: data, item_type: item_type).adapt }

      let(:data) { { title: Faker::Lorem.word } }

      it 'returns title' do
        expect(subject[:title]).to eq data[:title]
      end
    end

    context 'adapting released_at' do
      subject { described_class.new(data: data, item_type: item_type).adapt }

      context 'when dates_released_dts array has valid dates texts' do
        let(:data) { { dates_released_dts: [Time.zone.today.to_s, Time.zone.yesterday.to_s] } }

        it 'returns the earliest date' do
          expect(subject[:released_at]).to eq Time.zone.yesterday
        end
      end

      context 'when theres some error on parsing dates' do
        let(:data) do
          { dates_released_dts: ['som3 in4l1d d473', Time.zone.yesterday.to_s], date_from: Time.zone.tomorrow }
        end

        it 'returns date_from' do
          expect(subject[:released_at]).to eq Time.zone.tomorrow
        end
      end
    end

    context 'adapting pretty_release_date' do
      subject { described_class.new(data: data, item_type: item_type).adapt }

      let(:data) { { pretty_date_s: Faker::Lorem.word } }

      it 'returns pretty_release_date' do
        expect(subject[:pretty_release_date]).to eq data[:pretty_date_s]
      end
    end

    context 'adapting image_url' do
      subject { described_class.new(data: data, item_type: item_type).adapt }

      context 'when data has image_url_sq_s' do
        let(:data) { { image_url_sq_s: Faker::Lorem.word, image_url: Faker::Lorem.word } }

        it 'returns `https:` + image_url_sq_s' do
          expect(subject[:image_url]).to eq "https:#{data[:image_url_sq_s]}"
        end
      end

      context 'when data hasn`t image_url_sq_s' do
        let(:data) { { image_url_sq_s: nil, image_url: Faker::Lorem.word } }
        it 'returns `https:` + image_url' do
          expect(subject[:image_url]).to eq "https:#{data[:image_url]}"
        end
      end
    end

    context 'adapting website_url' do
      subject { described_class.new(data: data, item_type: item_type).adapt }

      let(:data) { { url: Faker::Lorem.word } }

      it 'returns nintendo uk website url + data url' do
        expect(subject[:website_url]).to eq "https://www.nintendo.co.uk#{data[:url]}"
      end
    end

    context 'adapting data' do
      subject { described_class.new(data: data, item_type: item_type).adapt }

      let(:data) { { some_data: Faker::Lorem.word } }

      it 'returns data' do
        expect(subject[:data]).to eq data
      end
    end
  end
end
