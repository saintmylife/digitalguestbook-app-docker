class AddJenisKategoriIdToGuest < ActiveRecord::Migration[5.1]
  def change
    add_column :guests, :jenis_kategori_id, :integer
    add_foreign_key :guests, :jenis_kategoris
  end
end
