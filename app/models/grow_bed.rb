class GrowBed < ApplicationRecord
  has_many :grow_bed_data
  belongs_to :sample_type

  validates :sample_type, :n_sample, presence: true

  scope :active, -> { where "active = 1" }
end
