class ChangeColumnAbsensi < ActiveRecord::Migration[5.1]
  def change
    rename_column :absensis, :checkin, :presence
    rename_column :absensis, :checkout, :souvenir
    rename_column :absensis, :time_of_in, :time_of_entry
    rename_column :absensis, :time_of_out, :time_of_get_souvenir
  end
end
