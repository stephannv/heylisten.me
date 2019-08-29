require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'Relations' do
    it { is_expected.to have_many(:events).with_dependent(:destroy) }
  end

  describe 'Fields' do
    it { is_expected.to have_timestamps }

    it { is_expected.to have_field(:item_type_cd).of_type(String) }
    it { is_expected.to have_field(:data_source_cd).of_type(String) }

    it { is_expected.to have_field(:identifier).of_type(String) }
    it { is_expected.to have_field(:nsuid).of_type(String) }
    it { is_expected.to have_field(:title).of_type(String) }
    it { is_expected.to have_field(:released_at).of_type(DateTime) }
    it { is_expected.to have_field(:pretty_release_date).of_type(String) }
    it { is_expected.to have_field(:image_url).of_type(String) }
    it { is_expected.to have_field(:website_url).of_type(String) }
    it { is_expected.to have_field(:data).of_type(Hash) }
  end

  describe 'Indexes' do
    it { is_expected.to have_index_for(data_source_cd: 1, identifier: 1).with_options(unique: true) }
    it { is_expected.to have_index_for(title: 1) }
    it { is_expected.to have_index_for(released_at: -1) }
  end

  describe 'Configurations' do
    it { is_expected.to be_mongoid_document }

    it 'has item_type enum' do
      enum = {
        'game' => 'game',
        'dlc' => 'dlc',
        'bundle' => 'bundle',
        'subscription' => 'subscription',
        'ticket' => 'ticket'
      }
      expect(described_class.item_types.hash).to eq(enum)
    end

    it 'has data_source enum' do
      enum = {
        'nintendo_europe' => 'nintendo_europe'
      }
      expect(described_class.data_sources.hash).to eq(enum)
    end
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:identifier) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:image_url) }
    it { is_expected.to validate_presence_of(:website_url) }
    it { is_expected.to validate_presence_of(:data) }
    it { is_expected.to validate_presence_of(:item_type_cd) }
    it { is_expected.to validate_presence_of(:data_source_cd) }

    it { is_expected.to validate_uniqueness_of(:identifier).scoped_to(:data_source_cd) }

    it { is_expected.to validate_length_of(:identifier).with_maximum(255) }
    it { is_expected.to validate_length_of(:title).with_maximum(255) }
    it { is_expected.to validate_length_of(:pretty_release_date).with_maximum(32) }
    it { is_expected.to validate_length_of(:image_url).with_maximum(255) }
    it { is_expected.to validate_length_of(:website_url).with_maximum(255) }
  end

  describe 'Callbacks' do
    describe 'After save' do
      context 'when is a new record' do
        let(:item) { create(:item) }

        it 'creates a item_added event' do
          expect { item }.to change(Event, :count).by(1)
          event = Event.last
          expect(event.item_id).to eq item.id
          expect(event).to be_item_added
          event_data = event.data.except('created_at', 'updated_at')
          expect(event_data).to eq item.attributes.except('created_at', 'updated_at')
        end
      end

      context 'when is a persisted record' do
        let!(:item) { create(:item) }

        context 'when title or pretty_release_date changed' do
          it 'creates a item_changed event' do
            [{ title: 'new title' }, { pretty_release_date: 'new release date' }].each do |new_attributes|
              expect { item.update(new_attributes) }.to change(Event, :count).by(1)
              event = Event.last
              expect(event.item_id).to eq item.id
              expect(event).to be_item_changed
              event_data = event.data.except('created_at', 'updated_at')
              expect(event_data).to eq item.attributes.except('created_at', 'updated_at')
            end
          end
        end

        context 'when title and pretty_release_date didn`t change' do
          it 'doesn`t create a event' do
            other_attributes = Item.attribute_names - %w[_id title pretty_release_date]
            other_item = build(:item)
            other_attributes.each do |attribute|
              expect do
                item.update!(attribute => other_item[attribute.to_sym])
              end.to_not change(Event, :count)
            end
          end
        end
      end

      context 'when a error happen' do
        let(:item) { create(:item) }

        before { allow_any_instance_of(Item).to receive(:_id_changed?).and_raise('random error') }

        it 'logs error' do
          expect(Rails.logger).to receive(:error)

          create(:item)
        end

        it 'returns true' do
          expect(create(:item)).to be_truthy
        end
      end
    end
  end
end
