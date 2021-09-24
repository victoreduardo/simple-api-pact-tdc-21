require 'rails_helper'

RSpec.describe Metric, type: :model do
  context 'validates' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:value) }
    it { should validate_presence_of(:date) }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_numericality_of(:value) }

    it 'date' do
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
