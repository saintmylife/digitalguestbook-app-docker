class ChangeColumnOnTableConcert < ActiveRecord::Migration[5.1]
  def change
  	rename_column :concerts, :category, :kategori
  	rename_column :concerts, :name, :nama
  	rename_column :concerts, :address, :alamat
  end
end
