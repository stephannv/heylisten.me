require 'rails_helper'

RSpec.describe NintendoNorthAmericaClient, type: :clients do
  describe 'Instance methods' do
    describe '#index_desc' do
      let(:index) { double }

      context 'when @index_desc is nil' do
        before do
          subject.instance_variable_set('@index_desc', nil)
          allow(Algolia::Index).to receive(:new).with('ncom_game_en_us_title_des').and_return(index)
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
          allow(Algolia::Index).to receive(:new).with('ncom_game_en_us_title_asc').and_return(index)
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
      let(:query) { Faker::Lorem.word }

      before do
        allow(index).to receive(:search)
          .with(query, queryType: 'prefixAll', hitsPerPage: 1000, filters: 'platform:"Nintendo Switch"')
          .and_return(response)
      end

      it 'returns hits from search result' do
        expect(subject.fetch(index: index, query: query)).to eq hits
      end
    end
  end
end
