require 'rails_helper'

RSpec.describe TweetPendingEvents, type: :mutations do
  describe 'Behavior' do
    let!(:pending_event_1) do
      item = create(:item)
      item.events.first.dispatches.first.update!(situation: :pending)
      item.events.first
    end

    let!(:pending_event_2) do
      item = create(:item)
      item.events.first.dispatches.first.update!(situation: :pending)
      item.events.first
    end

    let!(:failed_event) do
      item = create(:item)
      item.events.first.dispatches.first.update!(situation: :done)
      item.events.first
    end

    let(:previous_tweet) { double }

    before do
      allow(TweetEvent).to receive(:run!)
        .with(event: pending_event_1, previous_tweet: nil)
        .and_return(previous_tweet)
    end

    it 'tweet pending event message' do
      expect(TweetEvent).to receive(:run!).with(event: pending_event_1, previous_tweet: nil).ordered
      expect(TweetEvent).to receive(:run!).with(event: pending_event_2, previous_tweet: previous_tweet).ordered

      subject.execute
    end

    context 'when no errors happens' do
      it 'updates pending event to done' do
        allow(TweetEvent).to receive(:run!)
          .with(event: pending_event_2, previous_tweet: previous_tweet)
          .and_return(true)

        subject.execute

        expect(pending_event_1.reload.dispatches.first).to be_done
        expect(pending_event_2.reload.dispatches.first).to be_done
      end
    end

    context 'when errors happens' do
      before do
        allow(TweetEvent).to receive(:run!)
          .with(event: pending_event_2, previous_tweet: previous_tweet)
          .and_raise('some error')
      end

      it 'updates pending event to done' do
        subject.execute

        expect(pending_event_1.reload.dispatches.first).to be_done
        expect(pending_event_2.reload.dispatches.first).to be_failed
        expect(pending_event_2.reload.dispatches.first.message).to eq 'some error'
      end
    end
  end
end
