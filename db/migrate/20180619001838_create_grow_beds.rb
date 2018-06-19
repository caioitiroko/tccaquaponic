class CreateGrowBeds < ActiveRecord::Migration[5.2]
  def change
    create_table :grow_beds do |t|
      t.string :sample_type
      t.integer :n_sample
      t.boolean :active

      t.timestamps
    end
  end
end
