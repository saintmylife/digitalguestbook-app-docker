class AddColumnGuestIDtoGuests < ActiveRecord::Migration[5.1]
  def change
  	add_column :guests, :guest_id, :string
  end
end
