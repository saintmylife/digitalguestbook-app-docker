class ChangeColumnAbsensiAndAdd < ActiveRecord::Migration[5.1]
  def change
      add_column :absensis, :instansi, :string
      add_column :absensis, :jabatan, :string
      add_column :absensis, :unit_kerja, :string
      add_column :absensis, :other1, :string
      add_column :absensis, :other2, :string
      add_column :absensis, :other3, :string
  end
end
