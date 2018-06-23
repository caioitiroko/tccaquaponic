class AddColumnTitleToGrowBeds < ActiveRecord::Migration[5.2]
  def change
    add_column :grow_beds, :name, :string
    add_index :grow_beds, :name, unique: true
  end
end
