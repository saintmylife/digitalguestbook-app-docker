class AddWinnerColumnToGuests < ActiveRecord::Migration[5.1]
  def change
    add_column :guests, :winner, :boolean, default: :false
  end
end
