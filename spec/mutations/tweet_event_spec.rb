require 'rails_helper'

RSpec.describe TweetEvent, type: :mutations do
  describe 'Behavior' do
    subject { described_class.new(event: event, previous_tweet: previous_tweet) }

    let(:message) { Faker::Lorem.word }
    let(:event) { create(:event, message: message) }
    let(:image) { double }
    let(:previous_tweet) { double(id: Faker::Lorem.word) }

    before do
      allow(Down).to receive(:download).with(event.data['image_url'], max_size: 5 * 1024 * 1024).and_return(image)
    end

    it 'downloads item image and tweet it with event message' do
      expect_any_instance_of(Twitter::REST::Client).to receive(:update_with_media)
        .with(event.message, image, in_reply_to_status_id: previous_tweet.id)

      subject.execute
    end
  end
end
