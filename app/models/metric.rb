class Metric < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :value, presence: true, numericality: true
  validates :date, presence: true
  validates_datetime :date
end
