ActiveAdmin.register GrowBedDatum do
  menu priority: 3

  permit_params :date, :avg_width, :avg_length, :temperature, :water_flow, :lux, :ph, :n_fish, :grow_bed_id

  config.batch_actions = false
  config.sort_order = :date_desc

  filter :grow_bed_id, as: :select, collection: -> { GrowBed.all.map { |gb| [gb.name, gb.id] } }, label: I18n.t('activerecord.models.grow_bed')[:one]
  filter :date

  index do
    column t('activerecord.attributes.grow_bed_datum.grow_bed') do |gbd|
      gbd.grow_bed.name
    end
    column :date
    column :avg_length
    column :avg_width
    actions
  end

  show do
    attributes_table do
      row t('activerecord.attributes.grow_bed_datum.grow_bed') do |gbd|
        gbd.grow_bed.name
      end
      row :date
      row :avg_width
      row :avg_length
      row :temperature
      row :water_flow
      row :lux
      row :ph
      row :n_fish
    end
  end


  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs do
      f.semantic_errors :base

      f.input :grow_bed_id, :as => :select, :collection => GrowBed.active.map {|gb| [gb.name, gb.id]}, :include_blank => false
      f.input :date, as: :datepicker
      f.input :avg_width
      f.input :avg_length
      f.input :temperature
      f.input :water_flow
      f.input :lux
      f.input :ph
      f.input :n_fish
    end

    f.actions
  end

end
