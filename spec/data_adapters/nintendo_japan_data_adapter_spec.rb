require 'rails_helper'

describe NintendoJapanDataAdapter, type: :data_adapters do
  describe 'Adapted fields' do
    let(:data) { {} }

    subject { described_class.new(data: data).adapt }

    context 'adapting data_source' do
      it 'returns :nintendo_japan' do
        expect(subject[:data_source]).to eq :nintendo_japan
      end
    end

    context 'adapting item_type' do
      %w[dl_soft HAC_DOWNLOADABLE hac_dl hac_card].each do |sform|
        context "when sform is #{sform}" do
          let(:data) { { sform: sform } }

          it 'returns :game' do
            expect(subject[:item_type]).to eq :game
          end
        end
      end

      %w[dl_dlc dlc].each do |sform|
        context "when sform is #{sform}" do
          let(:data) { { sform: sform } }

          it 'returns :dlc' do
            expect(subject[:item_type]).to eq :dlc
          end
        end
      end

      [nil, Faker::Lorem.word].each do |sform|
        context "when sform is #{sform}" do
          let(:data) { { sform: sform } }

          it 'returns nil' do
            expect(subject[:item_type]).to eq nil
          end
        end
      end
    end

    context 'adapting nsuid' do
      let(:data) { { nsuid: Faker::Lorem.word } }

      it 'returns nsuid' do
        expect(subject[:nsuid]).to eq data[:nsuid]
      end
    end

    context 'adapting title' do
      let(:data) { { title: Faker::Lorem.word } }

      it 'returns title' do
        expect(subject[:title]).to eq data[:title]
      end
    end

    context 'adapting released_at' do
      context 'when dsdate is a valid date' do
        let(:data) { { dsdate: '2020-04-23 00:00:00', sdate: '2020.04.21' } }

        it 'returns dsdate' do
          expect(subject[:released_at]).to eq '2020-04-23'.to_date
        end
      end

      context 'when sdate is a valid date' do
        let(:data) { { dsdate: nil, sdate: '2020.04.21' } }

        it 'returns sdate' do
          expect(subject[:released_at]).to eq '2020.04.21'.to_date
        end
      end
    end

    context 'adapting pretty_release_date' do
      let(:data) { { sdate: '20.01.2020' } }

      it 'returns pretty_release_date' do
        expect(subject[:pretty_release_date]).to eq data[:sdate]
      end
    end

    context 'adapting image_url' do
      let(:data) { { iurl: Faker::Lorem.word } }

      it 'returns https://img-eshop.cdn.nintendo.net/i/ + iurl +.jpg?w=560&h=316' do
        expect(subject[:image_url]).to eq "https://img-eshop.cdn.nintendo.net/i/#{data[:iurl]}.jpg?w=560&h=316"
      end
    end

    context 'adapting website_url' do
      it 'returns nintendo uk website url + data url' do
      end

      let(:data) { { some_data: Faker::Lorem.word } }

      context 'when item type is game' do
        context 'when url is present' do
          let(:data) { { url: Faker::Lorem.word, sform: 'dl_soft' } }

          it 'returns url' do
            expect(subject[:website_url]).to eq data[:url]
          end
        end

        context 'when url isn`t present' do
          let(:data) { { url: nil, nsuid: Faker::Lorem.word, sform: 'dl_soft' } }

          it 'returns `https://ec.nintendo.com/JP/ja/titles/ + nsuid`' do
            expect(subject[:website_url]).to eq "https://ec.nintendo.com/JP/ja/titles/#{data[:nsuid]}"
          end
        end
      end

      context 'when item type isn`t game' do
        let(:data) { { sform: nil } }

        it 'returns NO WEBSITE text' do
          expect(subject[:website_url]).to eq 'NO WEBSITE'
        end
      end
    end

    context 'adapting data' do
      let(:data) { { some_data: Faker::Lorem.word } }

      it 'returns data' do
        expect(subject[:data]).to eq data
      end
    end
  end
end
