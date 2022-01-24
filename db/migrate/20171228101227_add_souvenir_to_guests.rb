class AddSouvenirToGuests < ActiveRecord::Migration[5.1]
  def change
    add_column :guests, :souvenir, :boolean
  end
end
