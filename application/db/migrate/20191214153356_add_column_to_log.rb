class AddColumnToLog < ActiveRecord::Migration[5.1]
  def change
      add_column :logs, :nama, :string
      add_column :logs, :alamat, :string
      add_column :logs, :kategori, :string
      add_column :logs, :instansi, :string
      add_column :logs, :jabatan, :string
      add_column :logs, :unit_kerja, :string
      add_column :logs, :other1, :string
      add_column :logs, :other2, :string
      add_column :logs, :other3, :string
  end
end
