class RemoveSampleTypeFromGrowBeds < ActiveRecord::Migration[5.2]
  def change
     remove_column :grow_beds, :sample_type
  end
end
