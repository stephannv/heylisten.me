require 'rails_helper'

RSpec.describe FetchNintendoJapanData, type: :mutations do
  describe 'Behavior' do
    let(:response_1) { [Faker::Lorem.word] }
    let(:response_2) { [Faker::Lorem.word] }
    let(:response_3) { nil }

    before do
      allow_any_instance_of(NintendoJapanClient).to receive(:fetch)
        .with(limit: 300, page: 1)
        .and_return(result: { items: response_1 })

      allow_any_instance_of(NintendoJapanClient).to receive(:fetch)
        .with(limit: 300, page: 2)
        .and_return(result: { items: response_2 })

      allow_any_instance_of(NintendoJapanClient).to receive(:fetch)
        .with(limit: 300, page: 3)
        .and_return(result: { items: response_3 })

      expect_any_instance_of(NintendoJapanClient).to receive(:fetch).exactly(3).times
    end

    it 'returns all paginated data from Nintendo Japan client' do
      expect(described_class.run!).to eq(response_1 + response_2)
    end
  end
end
