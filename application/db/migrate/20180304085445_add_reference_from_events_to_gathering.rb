class AddReferenceFromEventsToGathering < ActiveRecord::Migration[5.1]
  def change
  	add_column :gatherings, :event_id, :integer
  	add_foreign_key :gatherings, :events
  end
end
