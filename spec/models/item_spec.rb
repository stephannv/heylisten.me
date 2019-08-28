require 'rails_helper'

RSpec.describe Item, type: :model do
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
    it { is_expected.to have_index_for(data_source_cd: 1, title: 1).with_options(unique: true) }
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
    it { is_expected.to validate_presence_of(:released_at) }
    it { is_expected.to validate_presence_of(:pretty_release_date) }
    it { is_expected.to validate_presence_of(:image_url) }
    it { is_expected.to validate_presence_of(:website_url) }
    it { is_expected.to validate_presence_of(:data) }
    it { is_expected.to validate_presence_of(:item_type_cd) }
    it { is_expected.to validate_presence_of(:data_source_cd) }

    it { is_expected.to validate_uniqueness_of(:identifier).scoped_to(:data_source_cd) }
    it { is_expected.to validate_uniqueness_of(:title).scoped_to(:data_source_cd) }

    it { is_expected.to validate_length_of(:identifier).with_maximum(255) }
    it { is_expected.to validate_length_of(:title).with_maximum(255) }
    it { is_expected.to validate_length_of(:pretty_release_date).with_maximum(32) }
    it { is_expected.to validate_length_of(:image_url).with_maximum(255) }
    it { is_expected.to validate_length_of(:website_url).with_maximum(255) }
  end
end
