class RemoveTimeOfEntryFromGuest < ActiveRecord::Migration[5.1]
  def change
    remove_column :guests, :time_of_entry, :time
  end
end
