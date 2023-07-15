class CreateGuests < ActiveRecord::Migration[5.1]
  def change
    create_table :guests do |t|
    	t.string :name
    	t.string :address
    	t.string :telephone
    	t.boolean :presence
    	t.time :time_of_entry

      t.timestamps
    end
  end
end
