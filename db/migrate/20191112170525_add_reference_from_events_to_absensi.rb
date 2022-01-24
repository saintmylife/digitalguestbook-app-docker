class AddReferenceFromEventsToAbsensi < ActiveRecord::Migration[5.1]
  def change
  	add_column :absensis, :event_id, :integer
  	add_foreign_key :absensis, :events
    change_column_default :absensis, :checkin, false
    change_column_default :absensis, :checkout, false
  end
end
