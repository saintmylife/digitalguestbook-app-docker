class AddColumnInConcert < ActiveRecord::Migration[5.1]
  def change
  	add_column :concerts, :no_ktp, :string
  	add_column :concerts, :email, :string
  	add_column :concerts,  :no_ponsel, :string
  	add_column :concerts, :jenis_tiket, :string
  	add_column :concerts, :jumlah_tiket, :integer
  end
end
