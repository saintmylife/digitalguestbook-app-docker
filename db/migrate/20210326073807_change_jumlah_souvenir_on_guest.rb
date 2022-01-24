class ChangeJumlahSouvenirOnGuest < ActiveRecord::Migration[5.1]
  def change
    change_column :guests, :jumlah_souvenir, :string
  end
end
