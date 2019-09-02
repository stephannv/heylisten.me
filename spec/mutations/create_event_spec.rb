require 'rails_helper'

RSpec.describe CreateEvent, type: :mutations do
  describe 'Behavior' do
    let!(:item) { create(:item) }
    let(:event_type) { Event.event_types.values.sample }

    subject { described_class.new(item: item) }

    context 'when event type isn`t nil' do
      before { allow(subject).to receive(:event_type).and_return(event_type) }

      it 'creates an event for given item' do
        expect do
          subject.execute
        end.to change(item.events, :count).by(1)

        expect(item.events.last.event_type.to_s).to eq event_type
      end
    end

    context 'when event type is nil' do
      before { allow(subject).to receive(:event_type).and_return(nil) }

      it 'doesn`t create an event' do
        expect do
          subject.execute
        end.to_not change(item.events, :count)
      end
    end

    context 'when an error happens' do
      before { allow(item).to receive(:_id_changed?).and_raise('random error') }

      it 'logs error' do
        expect(Rails.logger).to receive(:error)

        subject.execute
      end

      it 'returns true' do
        expect(subject.execute).to be_truthy
      end
    end
  end

  describe 'Instance private methods' do
    describe '#event_type' do
      let(:item) { double }

      subject { described_class.new(item: item) }

      context 'when item has _id changed' do
        before { allow(item).to receive(:_id_changed?).and_return(true) }

        it 'returns :item_added' do
          expect(subject.send(:event_type)).to eq :item_added
        end
      end

      context 'when item has title or release date changed' do
        before { allow(item).to receive(:_id_changed?).and_return(false) }

        it 'returns :item_changed' do
          %i[title pretty_release_date].each do |attribute|
            allow(item).to receive("#{attribute}_changed?").and_return(true)

            expect(subject.send(:event_type)).to eq :item_changed
          end
        end
      end

      context 'when item hasn`t relevant changes' do
        before do
          %i[_id title pretty_release_date].each do |attribute|
            allow(item).to receive("#{attribute}_changed?").and_return(false)
          end
        end

        it 'returns nil' do
          expect(subject.send(:event_type)).to be_nil
        end
      end
    end
  end
end
