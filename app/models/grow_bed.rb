class GrowBed < ApplicationRecord
  validates :sample_type, :n_sample, presence: true
end
