class AddNamaUndanganAtauAngpauToGuest < ActiveRecord::Migration[5.1]
  def change
    add_column :guests, :nama_undangan_atau_angpau, :string
  end
end
