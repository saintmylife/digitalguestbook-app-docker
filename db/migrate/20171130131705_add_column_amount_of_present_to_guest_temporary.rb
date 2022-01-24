class AddColumnAmountOfPresentToGuestTemporary < ActiveRecord::Migration[5.1]
  def change
    add_column :guest_temporaries, :amount_of_present, :integer
  end
end
