class AddColumnJumlahSouvenirToGuests < ActiveRecord::Migration[5.1]
  def change
    add_column :guests, :jumlah_souvenir, :integer
  end
end
