class GrowBed < ApplicationRecord
  has_many :grow_bed_data

  validates :sample_type, :n_sample, presence: true
end
