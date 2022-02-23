class AddColumnJabatanToGuest < ActiveRecord::Migration[5.1]
  def change
  	add_column :guests,:jabatan, :string
  	rename_column :guests, :category, :kategori
  	rename_column :guests, :name, :nama
  	rename_column :guests, :city, :kota
  	rename_column :guests, :telephone, :nomor_ponsel
  	rename_column :guests, :type_of_guest, :status
  	rename_column :guests, :address, :alamat
  	remove_column :guests, :nama_undangan_atau_angpau
  end
end
