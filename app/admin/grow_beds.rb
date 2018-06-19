ActiveAdmin.register GrowBed do
  menu priority: 2

  permit_params :sample_type, :n_sample, :active
end
