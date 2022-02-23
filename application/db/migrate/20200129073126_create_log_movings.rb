class CreateLogMovings < ActiveRecord::Migration[5.1]
  def change
    create_table :logmovings do |t|
      t.string :guest_id
      t.integer :event_id

      t.string :nama
      t.string :alamat
      t.string :kategori
      t.string :instansi
      t.string :jabatan
      t.string :unit_kerja
      t.string :other1
      t.string :other2
      t.string :other3

      t.string :keterangan
      t.string :kelas
      t.time   :waktu

      t.boolean :status, default: :true

      t.timestamps

    end
  end
end
