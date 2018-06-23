ActiveAdmin.register SampleType do
  menu priority: 4

  permit_params :name

  config.batch_actions = false
  config.sort_order = :name_asc

  filter :name

  index do
    column :name
    actions
  end

  show do
    attributes_table do
      row :name
    end
  end


  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs do
      f.semantic_errors :base

      f.input :name
    end

    f.actions
  end
end
