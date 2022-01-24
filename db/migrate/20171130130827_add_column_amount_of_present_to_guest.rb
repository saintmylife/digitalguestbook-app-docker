class AddColumnAmountOfPresentToGuest < ActiveRecord::Migration[5.1]
  def change
    add_column :guests, :amount_of_present, :integer
  end
end
