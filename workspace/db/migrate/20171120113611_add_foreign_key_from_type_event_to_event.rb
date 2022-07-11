class AddForeignKeyFromTypeEventToEvent < ActiveRecord::Migration[5.1]
  def change
  	add_column :events, :type_of_event_id, :integer
  	add_foreign_key :events, :type_of_events
  end
end
