class GrowBedDatum < ApplicationRecord
  validates :date, :avg_width, :avg_length, :temperature, :water_flow, :lux, :ph, :n_fish, presence: true
end
