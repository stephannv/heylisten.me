require 'rails_helper'

RSpec.describe ImportNintendoSouthAmericaData, type: :mutations do
  subject { described_class.new }

  describe 'Behavior' do
    it 'fetches, parses and imports data from Nintendo Europe' do
      allow(subject).to receive(:fetch_data).and_return(true)
      allow(subject).to receive(:import_data).and_return(true)
      expect(subject).to receive(:fetch_data).ordered
      expect(subject).to receive(:import_data).ordered
      subject.execute
    end
  end

  describe 'Private instance methods' do
    describe '#fetch_data' do
      let(:data_collection) { double }

      before do
        allow(subject).to receive_message_chain('crawler.crawl').and_return(data_collection)
      end

      it 'assigns fetched data to @data_collection' do
        subject.send(:fetch_data)
        expect(subject.instance_variable_get('@data_collection')).to eq data_collection
      end
    end
  end

  describe '#import_data' do
    let(:data) { attributes_for(:item) }

    before { subject.instance_variable_set('@data_collection', [data]) }

    context 'when parsed data is valid' do
      context 'when identifier is already registered for given data_source' do
        before do
          create(:item,
            title: 'old title',
            data_source: data[:data_source],
            identifier: data[:identifier]
          )
        end

        it 'updates item' do
          expect { subject.send(:import_data) }.to_not change(Item, :count)
          updated_item = Item.find_by(data_source_cd: data[:data_source], identifier: data[:identifier])
          expect(updated_item.title).to eq data[:title]
        end
      end

      context 'when identifier doesn`t exist for given data_source' do
        it 'creates item' do
          expect { subject.send(:import_data) }.to change(Item, :count).by(1)
          created_item = Item.find_by(data_source_cd: data[:data_source], identifier: data[:identifier])
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

  describe '#crawler' do
    let(:crawler) { double }

    context 'when @crawler isn`t nil' do
      before { subject.instance_variable_set('@crawler', crawler) }

      it 'returns @crawler' do
        expect(subject.send(:crawler)).to eq crawler
      end
    end

    context 'when @crawler is nil' do
      before do
        subject.instance_variable_set('@crawler', nil)
        allow(NintendoSouthAmericaCrawler).to receive(:new).and_return(crawler)
      end

      it 'returns @crawler' do
        expect(subject.send(:crawler)).to eq crawler
      end
    end
  end
end
