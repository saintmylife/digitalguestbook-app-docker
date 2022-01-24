class AddJumlahUndaganInGuest < ActiveRecord::Migration[5.1]
  def change
  	add_column :guests, :jumlah_undangan, :integer
  end
end
