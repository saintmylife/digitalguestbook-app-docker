class CreateGuestTemporaries < ActiveRecord::Migration[5.1]
  def change
    create_table :guest_temporaries do |t|
    	t.string :name
    	t.string :address
    	t.string :telephone
    	t.boolean :presence
    	t.time :time_of_entry
    	t.string :city
    	t.string :category
    	t.string :type_of_guest
    	t.integer :no_undian
    	t.string :nama_meja
    	t.string :guest_id
    	t.integer :event_id

      t.timestamps
    end
  end
end
