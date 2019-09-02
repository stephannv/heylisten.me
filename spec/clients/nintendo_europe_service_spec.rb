require 'rails_helper'

RSpec.describe NintendoEuropeClient, type: :clients do
  describe 'Configurations' do
    it 'has specific base_uri' do
      expect(described_class.base_uri).to eq 'https://searching.nintendo-europe.com/en'
    end

    it 'has default_params' do
      expect(described_class.default_params).to eq(q: '*', sort: 'date_from desc')
    end
  end

  describe 'Public instance methods' do
    describe '#fetch' do
      let(:response) { { key: 'value' } }
      let(:fq_param) { { param: 'value' } }
      let(:limit) { Faker::Number.number(digits: 1) }
      let(:offset) { Faker::Number.number(digits: 1) }
      let(:data_type) { %w[game dlc].sample }
      let(:query_params) { described_class.default_params.merge(fq_param).merge(start: offset, rows: limit) }

      before do
        stub_request(:get, "#{described_class.base_uri}/select")
          .with(query: query_params)
          .to_return(body: response.to_json, headers: { 'Content-Type' => 'application/json' })

        allow(subject).to receive(:build_fq_param).with(data_type).and_return(fq_param)
      end

      it 'makes request and returns parsed response' do
        result = subject.fetch(limit: limit, offset: offset, data_type: data_type)
        expect(result).to eq response.with_indifferent_access
      end
    end
  end

  describe 'Private instance methods' do
    describe '#build_fq_param' do
      context 'when data_type is game' do
        it 'return `fq` param with type game and playable on HAC' do
          expect(subject.send(:build_fq_param, 'game')).to eq(fq: 'type:GAME AND playable_on_txt:"HAC"')
        end
      end

      context 'when data_type is dlc' do
        it 'returns `fq` param with type DLC' do
          expect(subject.send(:build_fq_param, 'dlc')).to eq(fq: 'type:DLC')
        end
      end

      context 'when data_type is unknown' do
        it 'raises error' do
          expect do
            subject.send(:build_fq_param, Faker::Lorem.word)
          end.to raise_error 'NOT SUPPORTED TYPE'
        end
      end
    end
  end
end
