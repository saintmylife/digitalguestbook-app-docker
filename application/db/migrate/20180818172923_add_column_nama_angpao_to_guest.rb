class AddColumnNamaAngpaoToGuest < ActiveRecord::Migration[5.1]
  def change
    add_column :guests, :nama_angpao, :text
  end
end
