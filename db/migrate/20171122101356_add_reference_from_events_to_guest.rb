class AddReferenceFromEventsToGuest < ActiveRecord::Migration[5.1]
  def change
  	add_column :guests, :event_id, :integer
  	add_foreign_key :guests, :events
  end
end
