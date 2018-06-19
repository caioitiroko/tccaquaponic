class CreateGrowBedData < ActiveRecord::Migration[5.2]
  def change
    create_table :grow_bed_data do |t|
      t.date :date
      t.float :avg_width
      t.float :avg_length
      t.float :temperature
      t.integer :water_flow
      t.float :lux
      t.float :ph
      t.integer :n_fish

      t.timestamps
    end
  end
end
