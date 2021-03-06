require 'rails_helper'

RSpec.describe FetchNintendoNorthAmericaData, type: :mutations do
  describe 'Behavior' do
    let(:response) { Faker::Lorem.word }

    before do
      allow_any_instance_of(described_class).to receive(:fetch_all_data).and_return(response)
    end

    it 'returns fetch_all_data result' do
      expect(described_class.run!).to eq response
    end
  end

  describe 'Private instance methods' do
    describe '#client' do
      let(:client) { double }

      context 'when @client isn`t nil' do
        before { subject.instance_variable_set('@client', client) }

        it 'returns @client' do
          expect(subject.send(:client)).to eq client
        end
      end

      context 'when @client is nil' do
        before do
          subject.instance_variable_set('@client', nil)
          allow(NintendoAlgoliaClient).to receive(:new).and_return(client)
        end

        it 'returns @client' do
          expect(subject.send(:client)).to eq client
        end
      end
    end

    describe '#fetch_data' do
      let(:response) { (1..999).to_a }
      let(:query) { Faker::Lorem.word }
      let(:client) { subject.send(:client) }

      before do
        allow(client).to receive(:fetch)
          .with(index: client.index_asc, query: query)
          .and_return(response)

        allow(client).to receive(:fetch)
          .with(index: client.index_desc, query: query)
          .and_return((1001..1050).to_a)
      end

      it 'fetches using asc index and given filter' do
        expect(subject.send(:fetch_data, query: query)).to eq response
      end

      context 'when first fetch returns 1000 items or more' do
        let(:response) { (1..1000).to_a }

        it 'fetches again using desc index' do
          expect(subject.send(:fetch_data, query: query)).to eq((1..1050).to_a)
        end
      end
    end

    describe '#queries' do
      it 'returns A to Z and 0 to 9' do
        expect(subject.send(:queries)).to eq(('a'..'z').to_a + ('0'..'9').to_a)
      end
    end

    describe '#fetch_all_data' do
      let(:filter_1) { Faker::Lorem.unique.word }
      let(:filter_2) { Faker::Lorem.unique.word }

      let(:object_1) { { objectID: 1 } }
      let(:object_2) { { objectID: 2 } }
      let(:object_3) { { objectID: 3 } }

      before do
        allow(subject).to receive(:queries).and_return([filter_1, filter_2])
        allow(subject).to receive(:fetch_data).with(query: filter_1).and_return([object_1, object_2])
        allow(subject).to receive(:fetch_data).with(query: filter_2).and_return([object_2, object_3])
      end

      it 'fetch data for each price filter and excludes duplicated items' do
        expect(subject.send(:fetch_all_data)).to eq [object_1, object_2, object_3]
      end
    end
  end
end
