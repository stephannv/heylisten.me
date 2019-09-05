require 'rails_helper'

RSpec.describe ImportData, type: :mutations do
  describe 'Behavior' do
    it 'imports Nintendo Europe and Nintendo North America data' do
      expect(ImportNintendoEuropeData).to receive(:run!).with(data_type: 'game')
      expect(ImportNintendoEuropeData).to receive(:run!).with(data_type: 'dlc')
      expect(ImportNintendoNorthAmericaData).to receive(:run!)

      subject.execute
    end
  end
end
