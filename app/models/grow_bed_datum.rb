require 'memoist'

class GrowBedDatum < ApplicationRecord
  extend Memoist

  belongs_to :grow_bed

  validates :date, :avg_width, :avg_length, :temperature, :water_flow, :lux, :ph, :n_fish, presence: true

  def self.recent(n)
    GrowBedDatum.order(date: :desc).first(n)
  end

  def growth_width
    avg_width - previous_datum.avg_width if previous_datum
  end

  def growth_length
    avg_length - previous_datum.avg_length if previous_datum
  end

  def previous_datum
    GrowBedDatum.where("date < :date and grow_bed_id = :grow_bed", { date: date, grow_bed: grow_bed  }).order(:date).last
  end

  memoize :growth_length, :growth_width, :previous_datum
end
