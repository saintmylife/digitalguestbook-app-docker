class ChangeDefaultJumlahSouvenirOnGuest < ActiveRecord::Migration[5.1]
  def change
      change_column_default :guests, :jumlah_souvenir, 1
  end
end
