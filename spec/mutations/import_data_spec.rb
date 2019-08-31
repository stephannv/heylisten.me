require 'rails_helper'

RSpec.describe ImportData, type: :mutations do
  describe 'Behavior' do
    it 'imports Nintendo Europe data' do
      expect(ImportNintendoEuropeData).to receive(:run!).with(data_type: 'game')
      expect(ImportNintendoEuropeData).to receive(:run!).with(data_type: 'dlc')

      subject.execute
    end
  end
end
