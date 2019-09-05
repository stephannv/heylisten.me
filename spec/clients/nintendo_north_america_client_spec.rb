require 'rails_helper'

RSpec.describe NintendoNorthAmericaClient, type: :clients do
  describe 'Constants' do
    it 'has PRICE_FILTERS constant' do
      expect(described_class::PRICES_FILTERS).to eq(
        [
          nil,
          'priceRange:"Free to start"',
          'priceRange:"$0 - $4.99"',
          'priceRange:"$5 - $9.99"',
          'priceRange:"$10 - $19.99"',
          'priceRange:"$20 - $39.99"',
          'priceRange:"$40+"'
        ]
      )
    end
  end

  describe 'Instance methods' do
    describe '#index_desc' do
      let(:index) { double }

      context 'when @index_desc is nil' do
        before do
          subject.instance_variable_set('@index_desc', nil)
          allow(Algolia::Index).to receive(:new).with('noa_aem_game_en_us_release_des').and_return(index)
        end

        it 'returns a algolia index with release date desc' do
          expect(subject.index_desc).to eq index
        end
      end

      context 'when @index_desc isn`t nil' do
        before do
          subject.instance_variable_set('@index_desc', index)
        end

        it 'returns @index_desc' do
          expect(Algolia::Index).to_not receive(:new)
          expect(subject.index_desc).to eq index
        end
      end
    end

    describe '#index_asc' do
      let(:index) { double }

      context 'when @index_asc is nil' do
        before do
          subject.instance_variable_set('@index_asc', nil)
          allow(Algolia::Index).to receive(:new).with('noa_aem_game_en_us_release_asc').and_return(index)
        end

        it 'returns a algolia index with release date desc' do
          expect(subject.index_asc).to eq index
        end
      end

      context 'when @index_asc isn`t nil' do
        before do
          subject.instance_variable_set('@index_asc', index)
        end

        it 'returns @index_asc' do
          expect(Algolia::Index).to_not receive(:new)
          expect(subject.index_asc).to eq index
        end
      end
    end

    describe '#fetch' do
      let(:index) { subject.index_desc }
      let(:hits) { [double] }
      let(:response) { { 'hits' => hits } }
      let(:filters) { subject.send(:build_filters, 'some filter') }

      before do
        allow(index).to receive(:search).with('', hitsPerPage: 1000, filters: filters).and_return(response)
      end

      it 'returns hits from search result' do
        expect(subject.fetch(index: index, price_filter: 'some filter')).to eq hits
      end
    end
  end

  describe 'Private instance methods' do
    describe '#build_filters' do
      context 'when prices_filter is nil' do
        it 'returns only platform filter' do
          expect(subject.send(:build_filters, nil)).to eq 'platform:"Nintendo Switch"'
        end
      end

      context 'when prices_filter isn`t nil' do
        let(:filter) { Faker::Lorem.word }

        it 'concatenates prices_filter with platform filter' do
          expect(subject.send(:build_filters, filter)).to eq('platform:"Nintendo Switch"' + ' AND ' + filter)
        end
      end
    end
  end
end
