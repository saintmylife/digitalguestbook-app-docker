class AddPresenceToGathering < ActiveRecord::Migration[5.1]
  def change
    add_column :gatherings, :presence, :boolean
    add_column :gatherings, :time_of_entry, :time
  end
end
