class AddSampleTypeReferenceToGrowBeds < ActiveRecord::Migration[5.2]
  def change
    add_reference :grow_beds, :sample_type, foreign_key: true
  end
end
