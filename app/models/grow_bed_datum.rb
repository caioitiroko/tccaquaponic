class GrowBedDatum < ApplicationRecord
  belongs_to :grow_bed

  validates :date, :avg_width, :avg_length, :temperature, :water_flow, :lux, :ph, :n_fish, presence: true
end
