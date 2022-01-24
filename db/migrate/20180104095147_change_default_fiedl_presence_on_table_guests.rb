class ChangeDefaultFiedlPresenceOnTableGuests < ActiveRecord::Migration[5.1]
  def change
    change_column_default :guests, :presence, false
  end
end
