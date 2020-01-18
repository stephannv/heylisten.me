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
        'nintendo_europe' => 'nintendo_europe',
        'nintendo_america' => 'nintendo_america',
        'nintendo_brasil' => 'nintendo_brasil'
      }
      expect(described_class.data_sources.hash).to eq(enum)
    end
  end

  describe 'Scopes' do
    describe '#from_south_america_with_dlc' do
      let!(:item_a) { create(:item, :game, data_source: :nintendo_brasil, data: { is_dlc_available: true }) }
      let!(:item_b) { create(:item, :game, data_source: :nintendo_brasil, data: { is_dlc_available: false }) }
      let!(:item_c) { create(:item, :game, data_source: :nintendo_america, data: { is_dlc_available: true }) }
      let!(:item_d) { create(:item, :dlc, data_source: :nintendo_brasil, data: { is_dlc_available: true }) }

      it 'returns items with dlc from south america' do
        scope_result = Item.from_south_america_with_dlc
        expect(scope_result).to include(item_a)
        expect(scope_result).to_not include(item_b)
        expect(scope_result).to_not include(item_c)
        expect(scope_result).to_not include(item_d)
      end
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
      it 'calls :create_event' do
        item = build(:item)
        expect(CreateEvent).to receive(:run!).with(item: item).twice
        item.save
        item.update(title: 'new title')
      end
    end
  end
end
