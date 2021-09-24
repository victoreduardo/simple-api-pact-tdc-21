require 'rails_helper'

RSpec.describe Metric, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }
    it { is_expected.to validate_numericality_of(:value) }

    it 'should date is valid' do
      subject.name = 'Foo Baa'
      subject.value = 12.22
      subject.date = 'test'

      expect(subject.valid?).to be(false)
      expect(subject.errors.full_messages).to eq(
        [
          "Date can't be blank",
          'Date translation missing: en.activerecord.errors.models.metric.attributes.date.invalid_datetime'
        ]
      )
    end
  end
end
