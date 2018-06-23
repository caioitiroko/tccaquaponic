ActiveAdmin.register GrowBed do
  menu priority: 2

  permit_params :name, :sample_type_id, :n_sample, :active

  config.batch_actions = false

  scope :all, default: true
  scope :active

  filter :id, as: :select, collection: -> { GrowBed.all.map { |gb| [gb.name, gb.id] } }, label: I18n.t('activerecord.models.grow_bed')[:one]
  filter :sample_type
  filter :n_sample

  index do
    column :name
    column :sample_type
    column :n_sample
    column :active
    actions
  end

  show do
    attributes_table do
      row :name
      row :sample_type
      row :n_sample
      row :active
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.semantic_errors :base

      f.input :name
      f.input :sample_type
      f.input :n_sample
      f.input :active

      f.actions
    end
  end
end
