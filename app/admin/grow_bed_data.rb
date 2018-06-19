ActiveAdmin.register GrowBedDatum do
  permit_params :date, :avg_width, :avg_length, :temperature, :water_flow, :lux, :ph, :n_fish, :grow_bed_id
end
