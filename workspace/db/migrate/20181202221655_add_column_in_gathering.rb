class AddColumnInGathering < ActiveRecord::Migration[5.1]
  def change
  	add_column :gatherings, :jabatan, :string
  	add_column :gatherings, :email, :string
  	add_column :gatherings, :no_ponsel, :string
  end
end
