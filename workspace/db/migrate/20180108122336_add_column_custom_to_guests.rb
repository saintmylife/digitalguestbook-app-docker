class AddColumnCustomToGuests < ActiveRecord::Migration[5.1]
  def change
    add_column :guests, :custom_one, :text
    add_column :guests, :custom_two, :text
    add_column :guests, :custom_three, :text
    add_column :guests, :custom_four, :text
    add_column :guests, :custom_five, :text
  end
end
