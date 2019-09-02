require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'Fields' do
    it { is_expected.to have_timestamps }

    it { is_expected.to have_field(:name).of_type(String) }
    it { is_expected.to have_field(:status).of_type(String) }
    it { is_expected.to have_field(:message).of_type(String) }
  end

  describe 'Indexes' do
    it { is_expected.to have_index_for(created_at: -1) }
  end

  describe 'Configurations' do
    it { is_expected.to be_mongoid_document }
  end

  describe 'Class methods' do
    describe '.start' do
      it 'creates a task' do
        expect { described_class.start('Task name') }.to change(Task, :count).by(1)
      end

      it 'runs passed block' do
        mock = double(field: 'teste')

        expect(mock).to receive(:field).twice

        described_class.start('Task name') do
          mock.field
          mock.field
        end
      end

      context 'when passed block executes successfully' do
        it 'updates task status to `finished`' do
          described_class.start('Task name') { 2 + 2 }

          expect(Task.last.status).to eq 'finished'
        end
      end

      context 'when passed block fails' do
        before do
          described_class.start('Task name') do
            raise 'error message'
          end
        end

        it 'updates task status to `failed`' do
          expect(Task.last.status).to eq 'failed'
        end

        it 'udpates message field with exception error message' do
          expect(Task.last.message).to eq 'RuntimeError - error message'
        end
      end
    end
  end
end
