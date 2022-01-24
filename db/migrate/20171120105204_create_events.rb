class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
			t.string :name
			t.date	:date
			t.string :event_owner
			t.boolean :status
			t.integer :number    	

      t.timestamps
    end
  end
end
