require 'rails_helper'

RSpec.describe NintendoJapanClient, type: :clients do
  describe 'Configurations' do
    it 'has specific base_uri' do
      expect(described_class.base_uri).to eq 'https://search.nintendo.jp/nintendo_soft'
    end

    it 'has default_params' do
      expect(described_class.default_params).to eq(
        opt_hard: '1_HAC',
        opt_osale: '1',
        sort: 'sodate desc',
        fq: %{
          ssitu_s:onsale
          OR ssitu_s:preorder
          OR (
            id:3347
            OR id:70010000013978
            OR id:70010000005986
            OR id:70010000004356
            OR id:ef5bf7785c3eca1ab4f3d46a121c1709
            OR id:3252
            OR id:3082
            OR id:20010000019167
          )
        }.squish
      )
    end
  end

  describe 'Public instance methods' do
    describe '#fetch' do
      let(:response) { { key: 'value' } }
      let(:limit) { Faker::Number.number(digits: 1) }
      let(:page) { Faker::Number.number(digits: 1) }
      let(:query_params) { described_class.default_params.merge(page: page, limit: limit) }

      before do
        stub_request(:get, "#{described_class.base_uri}/search.json")
          .with(query: query_params)
          .to_return(body: response.to_json, headers: { 'Content-Type' => 'application/json' })
      end

      it 'makes request and returns parsed response' do
        result = subject.fetch(page: page, limit: limit)
        expect(result).to eq response.with_indifferent_access
      end
    end
  end
end
