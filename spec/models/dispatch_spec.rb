require 'rails_helper'

RSpec.describe Dispatch, type: :model do
  describe 'Relations' do
    it { is_expected.to be_embedded_in(:event) }
  end

  describe 'Fields' do
    it { is_expected.to have_timestamps }

    it { is_expected.to have_field(:situation_cd).of_type(String) }
    it { is_expected.to have_field(:target_cd).of_type(String) }
    it { is_expected.to have_field(:message).of_type(String) }
  end

  describe 'Configurations' do
    it { is_expected.to be_mongoid_document }

    it 'has situation enum' do
      enum = {
        'pending' => 'pending',
        'done' => 'done',
        'failed' => 'failed'
      }
      expect(described_class.situations.hash).to eq(enum)
    end

    it 'has targets enum' do
      enum = {
        'twitter' => 'twitter',
        'discord' => 'discord'
      }
      expect(described_class.targets.hash).to eq(enum)
    end
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:situation_cd) }
    it { is_expected.to validate_presence_of(:target_cd) }
  end
end
