class AddColumnNamaAngpao < ActiveRecord::Migration[5.1]
  def change
    add_column :settings, :nama_angpao, :boolean
    add_column :settings, :jumlah_souvenir, :boolean
  end
end
