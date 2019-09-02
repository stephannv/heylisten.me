require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:item) }
    it { is_expected.to embed_many(:dispatches) }
  end

  describe 'Fields' do
    it { is_expected.to have_timestamps }

    it { is_expected.to have_field(:item_id).of_type(Object) }
    it { is_expected.to have_field(:event_type_cd).of_type(String) }
    it { is_expected.to have_field(:message).of_type(String) }
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

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:item_id) }
    it { is_expected.to validate_presence_of(:event_type_cd) }
    it { is_expected.to validate_presence_of(:data) }
    it { is_expected.to validate_presence_of(:message) }
  end

  describe 'Callbacks' do
    describe 'Before validation' do
      it 'fills message' do
        event = build(:event)
        message = Faker::Lorem.word
        allow(BuildEventMessage).to receive(:run!).with(event: event).and_return(message)
        event.validate
        expect(event.message).to eq message
      end
    end

    describe 'After create' do
      it 'creates a pending dispatch' do
        event = build(:event)

        expect { event.save }.to change(event.dispatches, :count).by(1)
        expect(event.dispatches.first).to be_pending
      end
    end
  end
end
