require 'rails_helper'

RSpec.describe ImportNintendoNorthAmericaData, type: :mutations do
  describe 'Behavior' do
    it 'fetches, parses and imports data from Nintendo North America' do
      allow(subject).to receive(:fetch_data).and_return(true)
      allow(subject).to receive(:parse_data).and_return(true)
      allow(subject).to receive(:import_data).and_return(true)
      expect(subject).to receive(:fetch_data).ordered
      expect(subject).to receive(:parse_data).ordered
      expect(subject).to receive(:import_data).ordered
      subject.execute
    end
  end

  describe 'Private instance methods' do
    describe '#fetch_data' do
      let(:data_collection) { double }

      before do
        allow(FetchNintendoNorthAmericaData).to receive(:run!).and_return(data_collection)
      end

      it 'assigns fetched data to @data_collection' do
        subject.send(:fetch_data)
        expect(subject.instance_variable_get('@data_collection')).to eq data_collection
      end
    end
  end

  describe '#parse_data' do
    let(:data_item) { double }
    let(:data_colletion) { [data_item] }
    let(:adapted_data) { double }
    let(:adapter) { double(adapt: adapted_data) }

    before do
      subject.instance_variable_set('@data_collection', data_colletion)
      allow(NintendoNorthAmericaDataAdapter).to receive(:new)
        .with(data: data_item)
        .and_return(adapter)
    end

    it 'assigns adapted data to @parsed_data_collection' do
      subject.send(:parse_data)
      expect(subject.instance_variable_get('@parsed_data_collection')).to eq [adapted_data]
    end
  end

  describe '#import_data' do
    let(:parsed_data) { attributes_for(:item) }

    before { subject.instance_variable_set('@parsed_data_collection', [parsed_data]) }

    context 'when parsed data is valid' do
      context 'when identifier is already registered for given data_source' do
        before do
          create(:item,
            title: 'old title',
            data_source: parsed_data[:data_source],
            identifier: parsed_data[:identifier]
          )
        end

        it 'updates item' do
          expect { subject.send(:import_data) }.to_not change(Item, :count)
          updated_item = Item.find_by(data_source_cd: parsed_data[:data_source], identifier: parsed_data[:identifier])
          expect(updated_item.title).to eq parsed_data[:title]
        end
      end

      context 'when identifier doesn`t exist for given data_source' do
        it 'creates item' do
          expect { subject.send(:import_data) }.to change(Item, :count).by(1)
          created_item = Item.find_by(data_source_cd: parsed_data[:data_source], identifier: parsed_data[:identifier])
          expect(created_item).to_not be_nil
        end
      end
    end

    context 'when parsed data is invalid' do
      before { allow_any_instance_of(Item).to receive(:save!).and_raise('random error') }

      it 'logs error' do
        expect(Rails.logger).to receive(:error).once
        subject.send(:import_data)
      end
    end
  end
end
