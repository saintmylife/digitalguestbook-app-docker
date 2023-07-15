class AddColumnToGuest < ActiveRecord::Migration[5.1]
  def change
  	add_column :guests, :city, :string
  	add_column :guests, :category, :string
  	add_column :guests, :type_of_guest, :string
  	add_column :guests, :no_undian, :integer
  	add_column :guests, :nama_meja, :string
  end
end
