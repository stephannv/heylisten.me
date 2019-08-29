require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'Fields' do
    it { is_expected.to have_timestamps }

    it { is_expected.to have_field(:item_id).of_type(Object) }
    it { is_expected.to have_field(:event_type_cd).of_type(String) }
    it { is_expected.to have_field(:data).of_type(Hash) }
  end

  describe 'Indexes' do
    it { is_expected.to have_index_for(item_id: 1) }
    it { is_expected.to have_index_for(event_type_cd: 1) }
    it { is_expected.to have_index_for(created_at: -1) }
  end

  describe 'Configurations' do
    it { is_expected.to be_mongoid_document }

    it 'has event_type enum' do
      enum = {
        'item_added' => 'item_added',
        'item_changed' => 'item_changed'
      }

      expect(described_class.event_types.hash).to eq(enum)
    end
  end
end
