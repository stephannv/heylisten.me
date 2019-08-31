require 'rails_helper'

RSpec.describe Dispatch, type: :model do
  describe 'Relations' do
    it { is_expected.to be_embedded_in(:event) }
  end

  describe 'Fields' do
    it { is_expected.to have_timestamps }

    it { is_expected.to have_field(:situation_cd).of_type(String) }
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
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:situation_cd) }
  end
end
