class RemoveNoUndianFromGuest < ActiveRecord::Migration[5.1]
  def change
    remove_column :guests, :no_undian, :integer
    remove_column :guests, :jenis_kategori_id, :integer
  end
end
