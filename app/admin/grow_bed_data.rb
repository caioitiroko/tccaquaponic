ActiveAdmin.register GrowBedDatum do
  menu priority: 3

  permit_params :date, :avg_width, :avg_length, :temperature, :water_flow, :lux, :ph, :n_fish, :grow_bed_id
end
