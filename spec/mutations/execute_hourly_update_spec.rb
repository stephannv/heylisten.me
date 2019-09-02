require 'rails_helper'

RSpec.describe ExecuteHourlyUpdate, type: :mutations do
  describe 'Behavior' do
    it 'imports data and tweet pending events' do
      expect(ImportData).to receive(:run!).ordered
      expect(TweetPendingEvents).to receive(:run!).ordered

      subject.execute
    end
  end
end
