class AddGrowBedReferrenceToGrowBedData < ActiveRecord::Migration[5.2]
  def change
    add_reference :grow_bed_data, :grow_bed, foreign_key: true
  end
end
