class AddTimeOfEntryToGuest < ActiveRecord::Migration[5.1]
  def change
    add_column :guests, :time_of_entry, 'timestamp with time zone'
  end
end
