class AddJkColumnInGathering < ActiveRecord::Migration[5.1]
  def change
  	add_column :gatherings,:jenis_kelamin,:string
  end
end
