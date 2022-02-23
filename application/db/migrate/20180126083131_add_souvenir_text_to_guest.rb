class AddSouvenirTextToGuest < ActiveRecord::Migration[5.1]
  def change
    add_column :guests, :souvenir_text, :text
  end
end
