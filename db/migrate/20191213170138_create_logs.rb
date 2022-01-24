class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.string :guest_id
      t.integer :event_id
      t.time :waktu
      t.string :keterangan

      t.timestamps
    end
  end
end
