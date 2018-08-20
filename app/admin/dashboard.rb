ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column span: 2 do
        if current_admin_user.last_sign_in_at && current_admin_user.last_sign_in_ip
          panel t('views.dashboard.last_access.title') do
            attributes_table_for OpenStruct.new(
              date: l(current_admin_user.last_sign_in_at, format: :short),
              ip: current_admin_user.last_sign_in_ip
            ) do
              row(t('views.dashboard.last_access.date')) { |object| object.date }
              row(t('views.dashboard.last_access.ip'))  { |object| object.ip }
            end
          end
        end
      end
      column span: 1 do
        panel "PH" do
          h1 class: "#{GrowBedDatum.last.ph_intensity} dashboard_ph" do
            GrowBedDatum.last.ph
          end
          small class: "dashboard_ph" do
            GrowBedDatum.last.date
          end
        end
      end
    end
    columns do
      column span: 2  do
        panel "DADOS MAIS RECENTES" do
          table_for GrowBedDatum.recent(5) do
            column  t('activerecord.attributes.grow_bed_datum.id'), :id do |datum|
              link_to("Dado ##{datum.id}", admin_grow_bed_datum_path(datum))
            end
            column t('activerecord.attributes.grow_bed_datum.date'), :date do |datum|
            datum.date
            end
            column t('activerecord.models.grow_bed.other'), :grow_bed do |datum|
              link_to(datum.grow_bed.name, admin_grow_bed_path(datum.grow_bed))
            end
          end
        end
      end
      column span: 1 do
      end
    end
  end
end
