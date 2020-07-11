require 'rails_helper'

RSpec.describe BuildEventWebhookData, type: :mutations do
  describe 'Behavior' do
    context 'when is a item addition event' do
      let(:event) { build(:event, event_type: :item_added) }
      let(:item_type) { event.data['item_type_cd'] }
      let(:event_message) { Faker::Lorem.word }

      before do
        allow_any_instance_of(described_class).to receive(:event_message).and_return(event_message)
      end

      it 'returns webhook_data' do
        expect(described_class.run!(event: event)).to eq(
          title: event.data['title'],
          url: event.data['website_url'],
          image_url: event.data['image_url'],
          fields: [
            {
              name: 'Event',
              value: event_message
            },
            {
              name: 'Release Date',
              value: event.data['pretty_release_date'] || 'TBD'
            }
          ]
        )
      end
    end
  end

  describe 'Private methods' do
    describe '#event_message' do
      subject { described_class.new(event: event) }

      let(:item_type) { event.data['item_type_cd'] }
      let(:data_source_title) { Faker::Lorem.word }

      before do
        allow_any_instance_of(described_class).to receive(:data_source_title).and_return(data_source_title)
      end

      context 'when event type is `item_added`' do
        let(:event) { build(:event, event_type: :item_added) }

        it 'returns `item type added - region` message' do
          expected_message = "#{event.data['item_type_cd'].titleize} added - #{data_source_title}"
          expect(subject.send(:event_message)).to eq expected_message
        end
      end

      context 'when event type is `item_changed`' do
        let(:event) { build(:event, event_type: :item_changed) }

        it 'returns `item type updated - region` message' do
          expected_message = "#{event.data['item_type_cd'].titleize} updated - #{data_source_title}"
          expect(subject.send(:event_message)).to eq expected_message
        end
      end
    end

    private def event_message
      item_type = event.data['item_type_cd'].titleize
      data_source = data_source_title(event.data['data_source_cd'])
      event_type = event.item_added? ? 'added' : 'updated'

      "#{item_type} #{event_type} - #{data_source}"
    end

    describe '#data_source_flags' do
      subject { described_class.new }

      context 'when data source is nintendo america' do
        it 'returns Mexico, Canada and USA flags' do
          expect(subject.send(:data_source_flags, :nintendo_america)).to eq '🇺🇸🇨🇦🇲🇽'
        end
      end

      context 'when data source is nintendo europe' do
        it 'returns european flag' do
          expect(subject.send(:data_source_flags, :nintendo_europe)).to eq '🇪🇺'
        end
      end

      context 'when data source is nintendo brasil' do
        it 'returns brazilian flag' do
          expect(subject.send(:data_source_flags, :nintendo_brasil)).to eq '🇧🇷'
        end
      end

      context 'when data source is nintendo brasil' do
        it 'returns brazilian flag' do
          expect(subject.send(:data_source_flags, :nintendo_japan)).to eq '🇯🇵'
        end
      end

      context 'when data source isn`t mapped' do
        it 'returns nil' do
          expect(subject.send(:data_source_flags, :nintendo_caucaia)).to be_nil
        end
      end
    end
  end
end
