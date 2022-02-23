class AddColumnJamAmbilSouvenirToGuest < ActiveRecord::Migration[5.1]
  def change
    add_column :guests, :time_of_get_souvenir, 'timestamp with time zone' 
  end
end
