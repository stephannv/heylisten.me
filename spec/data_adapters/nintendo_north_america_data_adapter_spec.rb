require 'rails_helper'

describe NintendoNorthAmericaDataAdapter, type: :data_adapters do
  describe 'Adapted fields' do
    let(:data) { {} }

    context 'adapting data_source' do
      subject { described_class.new(data: data).adapt }

      it 'returns :nintendo_america' do
        expect(subject[:data_source]).to eq :nintendo_america
      end
    end

    context 'adapting item_type' do
      subject { described_class.new(data: data).adapt }

      it 'returns :game' do
        expect(subject[:item_type]).to eq :game
      end
    end

    context 'adapting nsuid' do
      subject { described_class.new(data: data).adapt }

      let(:data) { { 'nsuid' => Faker::Lorem.word } }

      it 'returns nsuid' do
        expect(subject[:nsuid]).to eq data['nsuid']
      end
    end

    context 'adapting title' do
      subject { described_class.new(data: data).adapt }

      let(:data) { { 'title' => Faker::Lorem.word } }

      it 'returns title' do
        expect(subject[:title]).to eq data['title']
      end
    end

    context 'adapting released_at' do
      subject { described_class.new(data: data).adapt }

      context 'when releaseDateMask is a valid date' do
        let(:data) { { 'releaseDateMask' => Time.zone.yesterday.to_s } }

        it 'returns releaseDateMask converted to date' do
          expect(subject[:released_at]).to eq Time.zone.yesterday
        end
      end

      context 'when theres some error on parsing dates' do
        let(:data) { { 'releaseDateMask' => Faker::Lorem.word } }

        it 'returns 31/12/2050' do
          expect(subject[:released_at]).to eq '31/12/2050'.to_date
        end
      end
    end

    context 'adapting pretty_release_date' do
      subject { described_class.new(data: data).adapt }

      context 'when releaseDateMask is a valid date' do
        let(:data) { { 'releaseDateMask' => Time.zone.now.to_s } }

        it 'returns releaseDateMask converted to date' do
          expect(subject[:pretty_release_date]).to eq Time.zone.today.to_s
        end
      end

      context 'when theres some error on parsing dates' do
        let(:data) { { 'releaseDateMask' => Faker::Lorem.word } }

        it 'returns 31/12/2050' do
          expect(subject[:pretty_release_date]).to eq '31/12/2050'
        end
      end
    end

    context 'adapting image_url' do
      subject { described_class.new(data: data).adapt }

      let(:data) { { 'boxArt' => Faker::Lorem.word } }

      it 'returns `https:` + image_url_sq_s' do
        expect(subject[:image_url]).to eq "https://www.nintendo.com#{data['boxArt']}"
      end
    end

    context 'adapting website_url' do
      subject { described_class.new(data: data).adapt }

      let(:data) { { 'url' => Faker::Lorem.word } }

      it 'returns nintendo website url + data url' do
        expect(subject[:website_url]).to eq "https://www.nintendo.com#{data['url']}"
      end
    end

    context 'adapting data' do
      subject { described_class.new(data: data).adapt }

      let(:data) { { 'some_data' => Faker::Lorem.word, '_highlightResult' => double } }

      it 'returns data' do
        expect(subject[:data]).to eq data.except('_highlightResult')
      end
    end
  end
end
