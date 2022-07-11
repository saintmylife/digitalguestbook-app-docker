class AddJumlahUndanganToSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :settings, :jumlah_undangan, :boolean, default: :false
  end
end
