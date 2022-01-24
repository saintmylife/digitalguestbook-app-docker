class CreateTableConcert < ActiveRecord::Migration[5.1]
  def change
    create_table :concerts do |t|
      t.string :guest_id
      t.boolean :presence
      t.time :time_of_entry

      t.timestamps
    end
  end
end
