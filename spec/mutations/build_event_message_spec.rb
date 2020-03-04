require 'rails_helper'

RSpec.describe BuildEventMessage, type: :mutations do
  describe 'Behavior' do
    context 'when is a item addition event' do
      let(:event) { build(:event, event_type: :item_added) }
      let(:item_type) { event.data['item_type_cd'] }
      let(:data_source) { event.data['data_source_cd'].humanize.titleize }

      before do
        allow_any_instance_of(described_class).to receive(:data_source_flags)
          .with(event.data['data_source_cd'])
          .and_return('🇧🇷')
      end

      it 'returns message with addition text' do
        message = <<~MSG
          Hey, Listen! A new #{item_type} was added to #{data_source} 🇧🇷.

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

      before do
        allow_any_instance_of(described_class).to receive(:data_source_flags)
          .with(event.data['data_source_cd'])
          .and_return('🇧🇷')
      end

      it 'returns message with update text' do
        message = <<~MSG
          Hey, Listen! There was an update on a #{item_type} on #{data_source} 🇧🇷.

          #{event.data['title']}
          Release date: #{event.data['pretty_release_date']}

          More info at: #{event.data['website_url']}
        MSG

        expect(described_class.run!(event: event)).to eq message.strip
      end
    end

    context 'when is a item doesn`t have pretty release_date' do
      let(:event) { build(:event, event_type: :item_changed) }
      let(:item_type) { event.data['item_type_cd'] }
      let(:data_source) { event.data['data_source_cd'].humanize.titleize }

      it 'doesn`t add release date to message' do
        event.data['pretty_release_date'] = nil

        expect(described_class.run!(event: event)).to_not include('Release date: ')
      end
    end
  end

  describe 'Private methods' do
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
