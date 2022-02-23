class CreateMovings < ActiveRecord::Migration[5.1]
  def change
    create_table :movings do |t|

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

      t.boolean :presence, default: :false
      t.boolean :souvenir, default: :false

      t.boolean :winner, default: :true

      t.timestamps

    end
  end
end
