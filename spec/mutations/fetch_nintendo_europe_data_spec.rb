require 'rails_helper'

RSpec.describe FetchNintendoEuropeData, type: :mutations do
  describe 'Behavior' do
    let(:data_type) { %w[game dlc].sample }
    let(:response_1) { [Faker::Lorem.word] }
    let(:response_2) { [Faker::Lorem.word] }
    let(:response_3) { nil }

    before do
      allow_any_instance_of(NintendoEuropeClient).to receive(:fetch)
        .with(limit: 1000, offset: 0, data_type: data_type)
        .and_return(response: { docs: response_1 })

      allow_any_instance_of(NintendoEuropeClient).to receive(:fetch)
        .with(limit: 1000, offset: 1000, data_type: data_type)
        .and_return(response: { docs: response_2 })

      allow_any_instance_of(NintendoEuropeClient).to receive(:fetch)
        .with(limit: 1000, offset: 2000, data_type: data_type)
        .and_return(response: { docs: response_3 })

      expect_any_instance_of(NintendoEuropeClient).to receive(:fetch).exactly(3).times
    end

    it 'returns all paginated data from Nintendo Europe client' do
      expect(described_class.run!(data_type: data_type)).to eq(response_1 + response_2)
    end
  end
end
