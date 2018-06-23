ActiveAdmin.register GrowBed do
  menu priority: 2

  permit_params :name, :sample_type, :n_sample, :active

  scope :all, default: true
  scope :active

end
