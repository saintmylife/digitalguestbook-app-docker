class CreateAbsensis < ActiveRecord::Migration[5.1]
  def change
    create_table :absensis do |t|
      t.string :guest_id
      # t.integer :event_id
      t.string :nama
      t.string :alamat
      t.string :kategori

      # t.boolean :presence, default: :false
      t.boolean :checkin
      # t.time :time_of_entry
      t.time :time_of_in

      # t.boolean :souvenir, default: :false
      t.boolean :checkout
      # t.time :time_of_get_souvenir
      t.time :time_of_out

      t.timestamps
    end
  end
end
