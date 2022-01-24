class ChangeDefaultFiedlSouvenirOnTableGuests < ActiveRecord::Migration[5.1]
  def change
    change_column_default :guests, :souvenir, false
  end
end
