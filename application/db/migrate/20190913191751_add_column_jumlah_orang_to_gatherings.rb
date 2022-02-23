class AddColumnJumlahOrangToGatherings < ActiveRecord::Migration[5.1]
  def change
    add_column :gatherings,:jumlah_orang, :integer
  end
end
