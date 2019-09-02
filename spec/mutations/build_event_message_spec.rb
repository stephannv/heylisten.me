require 'rails_helper'

RSpec.describe BuildEventMessage, type: :mutations do
  describe 'Behavior' do
    context 'when is a item addition event' do
      let(:event) { build(:event, event_type: :item_added) }
      let(:item_type) { event.data['item_type_cd'] }
      let(:data_source) { event.data['data_source_cd'].humanize.titleize }

      it 'returns message with addition text' do
        message = <<~MSG
          Hey, Listen! A new #{item_type} was added to #{data_source}.

          #{event.data['title']}
          Release date: #{event.data['pretty_release_date']}

          More info at: #{event.data['website_url']}
        MSG

        expect(described_class.run!(event: event)).to eq message.strip
      end
    end

    context 'when is a item addition event' do
      let(:event) { build(:event, event_type: :item_changed) }
      let(:item_type) { event.data['item_type_cd'] }
      let(:data_source) { event.data['data_source_cd'].humanize.titleize }

      it 'returns message with update text' do
        message = <<~MSG
          Hey, Listen! There was an update on a #{item_type} on #{data_source}.

          #{event.data['title']}
          Release date: #{event.data['pretty_release_date']}

          More info at: #{event.data['website_url']}
        MSG

        expect(described_class.run!(event: event)).to eq message.strip
      end
    end
  end
end
